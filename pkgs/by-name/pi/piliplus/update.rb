#! /usr/bin/env nix-shell
#! nix-shell -i ruby -p ruby nix-prefetch-git

require 'net/http'
require 'json'
require 'open3'
require 'yaml'

PACKAGE = 'piliplus'

def log(...) = $stderr.puts(...)
def finish(...) = log(...) || exit

def package_attr attr_path
  stdout, status = Open3.capture2 'nix-instantiate', '--eval', '--json', '--attr', "#{PACKAGE}.#{attr_path}"
  abort "nix-instantiate failed with exit code #{status.exitstatus} when reading attr #{attr_path}" unless status.success?
  JSON.parse stdout rescue abort "Failed to parse JSON output from nix-instantiate when reading attr #{attr_path}"
end

def github_api path, token: ENV['GITHUB_TOKEN'], headers: []
  uri = URI.join 'https://api.github.com', path
  res = Net::HTTP.start uri.host, uri.port, use_ssl: true do |http|
    req = Net::HTTP::Get.new uri
    req['Authorization'] = "Bearer #{token}" if token
    http.request req
  end
  abort "Failed to fetch #{path}: #{res.code} #{res.message}" unless res.is_a? Net::HTTPSuccess
  body = JSON.parse res.body rescue abort "Failed to parse JSON response from GitHub"
  return body if headers.empty?
  header_values = headers.map { res[_1] }
  [body, *header_values]
end

def prefetch_git url, rev
  stdout, status = Open3.capture2 'nix-prefetch-git', '--url', url, '--rev', rev
  abort "nix-prefetch-git failed with exit code #{status.exitstatus}" unless status.success?
  JSON.parse stdout rescue abort "Failed to parse JSON output from nix-prefetch-git"
end

def json_write filename, object
  File.open(filename, 'w') { _1.puts JSON.pretty_generate object }
end

owner = package_attr 'src.owner'
repo = package_attr 'src.repo'
git_url = "https://github.com/#{owner}/#{repo}.git"

old_version = package_attr 'version'
old_rev = package_attr 'src.rev'
old_hash = package_attr 'src.outputHash'
log "Current version: #{old_version} #{old_rev} #{old_hash}"

new_version = github_api("/repos/#{owner}/#{repo}/releases/latest")['tag_name'] or abort "No `tag_name` field in GitHub response"
finish "Already up-to-date" if new_version == old_version
new_rev, new_hash, src_path, date = prefetch_git(git_url, new_version).values_at 'rev', 'hash', 'path', 'date'
date = Time.new(date).to_i
log "New version: #{new_version} #{new_rev} #{new_hash}"

_, commit_links = github_api "/repos/#{owner}/#{repo}/commits?sha=#{new_rev}&per_page=1", headers: ['link']
git_count = commit_links[/[&?]page=(\d+)>; rel="last"/, 1]&.to_i
abort "Cannot determine git commit count from GitHub response" unless git_count

nix_filename = package_attr('meta.position')[/([^:]+):\d+/, 1] or abort "Failed to find the Nix file to be updated"
nix_dir = File.dirname nix_filename
src_info_path = File.join nix_dir, 'src-info.json'
json_write src_info_path, {
  version: new_version,
  rev: new_rev,
  revCount: git_count,
  commitDate: date,
  hash: new_hash
}
log "Updated #{src_info_path}"

pubspec_lock_path = File.join nix_dir, 'pubspec.lock.json'
old_pubspec_lock = JSON.load_file pubspec_lock_path rescue abort "Failed to read #{pubspec_lock_path}"
new_pubspec_lock = YAML.load_file File.join src_path, 'pubspec.lock' rescue abort "Failed to read pubspec.lock"
json_write pubspec_lock_path, new_pubspec_lock
log "Updated #{pubspec_lock_path}"

git_hashes_path = File.join nix_dir, 'git-hashes.json'
old_git_hashes = JSON.load_file git_hashes_path rescue abort "Failed to read #{git_hashes_path}"
new_git_hashes = {}
new_pubspec_lock['packages'].each do |name, info|
  next unless info['source'] == 'git'
  old_description = old_pubspec_lock.dig 'packages', name, 'description'
  new_description = info['description']
  if old_description == new_description
    new_git_hashes[name] = old_git_hashes[name]
    log "Reused existing git hash for dependency #{name}"
    next
  end
  log "Updating git hash for dependency #{name}..."
  url, rev = new_description.values_at 'url', 'resolved-ref'
  new_git_hashes[name] = prefetch_git(url, rev)['hash']
end
json_write git_hashes_path, new_git_hashes
log "Updated #{git_hashes_path}"

finish "All done"
