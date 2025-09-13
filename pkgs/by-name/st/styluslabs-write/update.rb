#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p ruby nix-prefetch-git

require 'net/http'
require 'json'
require 'open3'

PACKAGE = 'styluslabs-write'

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
  stdout, status = Open3.capture2 'nix-prefetch-git', '--url', url, '--rev', rev, '--fetch-submodules'
  abort "nix-prefetch-git failed with exit code #{status.exitstatus}" unless status.success?
  JSON.parse stdout rescue abort "Failed to parse JSON output from nix-prefetch-git"
end

def replace_in_file filename, searches, replacements
  contents = File.read filename
  searches.zip replacements do |search, replacement|
    contents.sub! search, replacement or abort "Failed to replace #{search} -> #{replacement} in #{filename}"
  end
  File.write filename, contents
end

owner = package_attr 'src.owner'
repo = package_attr 'src.repo'

old_version = package_attr 'version'
old_rev = package_attr 'src.rev'
old_hash = package_attr 'src.outputHash'
log "Current version: #{old_version} #{old_rev} #{old_hash}"

latest_release = github_api "/repos/#{owner}/#{repo}/releases/latest"
tag = latest_release['tag_name'] or abort "No `tag_name` field in GitHub response"
new_rev, new_hash, date = prefetch_git("https://github.com/#{owner}/#{repo}.git", tag).values_at 'rev', 'hash', 'date'
_, commit_links = github_api "/repos/#{owner}/#{repo}/commits?sha=#{new_rev}&per_page=1", headers: ['link']
git_count = commit_links[/[&?]page=(\d+)>; rel="last"/, 1]
abort "Cannot determine git commit count from GitHub response" unless git_count
new_version = Time.new(date).utc.strftime '%Y-%m-%d' rescue abort "Failed to parse commit date #{date}"
finish 'No need to update' if old_version == new_version
log "New version: #{new_version} #{new_rev} #{new_hash}"

nix_filename = package_attr('meta.position')[/([^:]+):\d+/, 1] or abort "Failed to find the Nix file to be updated"
replace_in_file nix_filename, [old_version, old_rev, old_hash, /GITCOUNT=\d+/], [new_version, new_rev, new_hash, "GITCOUNT=#{git_count}"]
log "Updated #{nix_filename}"
