#!/usr/bin/env nix-shell
#! nix-shell -i nu -p nushell nix-prefetch-github common-updater-scripts

use std/log

let version_info = "./pkgs/by-name/gr/graphhopper/version.toml"

let current_version = open $version_info

let latest_tag = list-git-tags --url=https://github.com/graphhopper/graphhopper
    | lines
    | sort --natural
    | where ($it =~ '^[\d.]+$')
    | last

if $current_version.patch == $latest_tag {
    log debug "Current graphhopper version matched latest version of graphhopper, no update is needed, exiting..."
    exit 0
}

let major = $latest_tag
    | str replace -ar '(\d+)\.\d+' '$1.0'

log debug $"Fetching source for graphhopper patch ($latest_tag) on version ($major)"
let source = nix-prefetch-github graphhopper graphhopper --rev $latest_tag
    | from json

log debug $"Reading maps bundle version for ($latest_tag)"
let web_bundle_pom = http get $"https://api.github.com/repos/graphhopper/graphhopper/contents/web-bundle/pom.xml?ref=($latest_tag)"
    | $in.content
    | base64 --decode
    | into string
    | from xml

let maps_bundle_properties = $web_bundle_pom.content
    | where ($it.tag =~ "properties")
    | first

let maps_bundle_version = $maps_bundle_properties.content
    | where ($it.tag =~ "graphhopper-maps.version")
    | first
    | $in.content
    | first
    | $in.content

log debug $"Fetching maps bundle ($maps_bundle_version)"
let maps_bundle_hash = nix-prefetch-url $"https://registry.npmjs.org/@graphhopper/graphhopper-maps-bundle/-/graphhopper-maps-bundle-($maps_bundle_version).tgz"
    | nix-hash --type sha256 --to-base64 $in
    | ["sha256-", $in]
    | str join

log debug $"Writing to ($version_info) without mvnDeps hash..."

{
    major: $major,
    patch: $latest_tag,
    mapsBundle: $maps_bundle_version,

    hash: {
        src: $source.hash
        mapsBundle: $maps_bundle_hash
        mvnDeps: "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
    }
}
    | to toml
    | save $version_info -f

log debug "Calculating mvnDeps hash..."
let graphhopper_build_logs = nix-build -A graphhopper o+e>| cat

let mvn_hash_lines = $graphhopper_build_logs
    | lines
    | find "got:"

if ($mvn_hash_lines | length) == 0 {
    log error $"Could not find any maven hash in the graphhopper build logs - maybe a different error occurred: \n$($graphhopper_build_logs)"
    exit 1
}

log debug $"Found relevant hash lines: ($mvn_hash_lines)"
let mvn_hash = $mvn_hash_lines
    | first
    | ansi strip
    | str replace 'got:' ''
    | str trim

log debug $"Writing to ($version_info) with mvnDeps hash ($mvn_hash).."
{
    major: $major,
    patch: $latest_tag,
    mapsBundle: $maps_bundle_version,

    hash: {
        src: $source.hash
        mapsBundle: $maps_bundle_hash
        mvnDeps: $mvn_hash
    }
}
    | to toml
    | save $version_info -f

log debug $"Successfully updated graphhopper package!"
