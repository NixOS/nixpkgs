#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p ruby

require 'net/http'
require 'json'
require 'open3'

PACKAGE = 'styluslabs-write-bin'
GITHUB_REPO = 'styluslabs/Write'

def log(...) = $stderr.puts(...)
def finish(...) = log(...) || exit

def package_attr attr_path
  stdout, status = Open3.capture2 'nix-instantiate', '--eval', '--json', '--attr', "#{PACKAGE}.#{attr_path}"
  abort "nix-instantiate failed with exit code #{status.exitstatus} when reading attr #{attr_path}" unless status.success?
  JSON.parse stdout rescue abort "Failed to parse JSON output from nix-instantiate when reading attr #{attr_path}"
end

def github_api path, token: ENV['GITHUB_TOKEN']
  uri = URI.join 'https://api.github.com', path
  res = Net::HTTP.start uri.host, uri.port, use_ssl: true do |http|
    req = Net::HTTP::Get.new uri
    req['Authorization'] = "Bearer #{token}" if token
    http.request req
  end
  abort "Failed to fetch #{path}: #{res.code} #{res.message}" unless res.is_a? Net::HTTPSuccess
  JSON.parse res.body rescue abort "Failed to parse JSON response from GitHub"
end

def prefetch_url url
  stdout, status = Open3.capture2 'nix-prefetch-url', '--unpack', url
  abort "nix-prefetch-url failed with exit code #{status.exitstatus} when fetching #{url}" unless status.success?
  stdout, status = Open3.capture2 'nix', '--extra-experimental-features', 'nix-command', 'hash', 'convert', '--hash-algo', 'sha256', stdout.strip
  abort "nix hash convert failed with exit code #{status.exitstatus} when hashing #{url}" unless status.success?
  stdout.strip
end

def replace_in_file filename, searches, replacements
  contents = File.read filename
  searches.zip replacements do |search, replacement|
    contents.sub! search, replacement or abort "Failed to replace #{search} -> #{replacement} in #{filename}"
  end
  File.write filename, contents
end

old_version = package_attr 'version'
old_url = package_attr 'src.url'
old_hash = package_attr 'src.outputHash'
log "Current version: #{old_version} #{old_hash}"

latest_release = github_api "/repos/#{GITHUB_REPO}/releases/latest"
tag = latest_release['tag_name'] or abort "No `tag_name` field in GitHub response"
rev = github_api("/repos/#{GITHUB_REPO}/git/ref/tags/#{tag}").dig 'object', 'sha'
abort "No `object.sha` field in GitHub response" unless rev
commit = github_api "/repos/#{GITHUB_REPO}/git/commits/#{rev}"
date = commit.dig 'commit', 'author', 'date'
date ||= commit.dig 'author', 'date'
abort "No `commit.author.date` field in GitHub response" unless date
new_version = Time.new(date).utc.strftime '%Y-%m-%d' rescue abort "Failed to parse commit date #{date}"
finish 'No need to update' if old_version == new_version
log "Latest version: #{new_version} (tag #{tag})"

new_url = latest_release['assets']&.find { _1['name'].end_with? '.tar.gz' }&.[] 'browser_download_url'
abort "No suitable asset found in the latest release" unless new_url
new_hash = prefetch_url new_url
log "New src: #{new_url} #{new_hash}"

nix_filename = package_attr('meta.position')[/([^:]+):\d+/, 1]
abort "Failed to find the Nix file to be updated" unless nix_filename
replace_in_file nix_filename, [old_version, old_url, old_hash], [new_version, new_url, new_hash]
log "Updated #{nix_filename}"
