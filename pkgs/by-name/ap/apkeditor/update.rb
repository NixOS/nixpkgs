#!/usr/bin/env nix-shell
#!nix-shell -i ruby -p ruby nix-prefetch-git

require 'net/http'
require 'json'
require 'open3'

def log(...) = $stderr.puts(...)
def finish(...) = log(...) || exit

def nixpkgs_attr attr_path
  stdout, status = Open3.capture2 'nix-instantiate', '--eval', '--json', '--attr', attr_path
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

def prefetch_git url, rev = nil
  stdout, status = Open3.capture2 'nix-prefetch-git', '--url', url, *(rev ? ['--rev', rev] : [])
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

def update_mitm_cache package
  nixpkgs_attr "#{package}.mitmCache.name" rescue return
  stdout, status = Open3.capture2 'nix-build', '-A', "#{package}.mitmCache.updateScript"
  abort "Failed to build #{package}.mitmCache.updateScript" unless status.success?
  stdout, status = Open3.capture2 stdout.strip
  abort "Failed to update mitmCache for #{package}" unless status.success?
end

def update package
  log "Updating #{package}..."

  owner = nixpkgs_attr "#{package}.src.owner"
  repo = nixpkgs_attr "#{package}.src.repo"

  old_version = nixpkgs_attr "#{package}.version"
  use_last_commit = old_version.include? 'unstable'
  old_hash = nixpkgs_attr "#{package}.src.outputHash"
  if use_last_commit
    old_rev = nixpkgs_attr "#{package}.src.rev"
    log "Current version: #{old_version} #{old_rev} #{old_hash}"
  else
    log "Current version: #{old_version} #{old_hash}"
  end

  nix_filename = nixpkgs_attr("#{package}.meta.position")[/([^:]+):\d+/, 1] or abort "Failed to find the Nix file to be updated"

  if use_last_commit
    new_rev, date, new_hash = prefetch_git("https://github.com/#{owner}/#{repo}.git").values_at 'rev', 'date', 'hash'
    return log 'Already up to date' if new_rev == old_rev
    new_version = old_version[/(.*unstable-).+/, 1] + Time.new(date).utc.strftime('%Y-%m-%d')
    log "New version: #{new_version} #{new_rev} #{new_hash}"
    replace_in_file nix_filename, [old_version, old_rev, old_hash], [new_version, new_rev, new_hash]
  else
    tag = github_api("/repos/#{owner}/#{repo}/releases/latest")&.[] 'tag_name'
    abort "Failed to get latest release tag from GitHub" unless tag
    new_version = tag[/^V(.*)/, 1] or abort "Failed to parse version from tag #{tag}"
    return log 'Already up to date' if new_version == old_version
    new_hash = prefetch_git("https://github.com/#{owner}/#{repo}.git", tag)['hash']
    log "New version: #{new_version} #{new_hash}"
    replace_in_file nix_filename, [old_version, old_hash], [new_version, new_hash]
  end

  update_mitm_cache package
end

update 'apkeditor.passthru.deps.arsclib'
update 'apkeditor.passthru.deps.smali'
update 'apkeditor.passthru.deps.jcommand'
update 'apkeditor'

finish 'All done'
