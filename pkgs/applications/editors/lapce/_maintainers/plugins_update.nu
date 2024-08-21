#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell

cd $env.FILE_PWD
cd .. # exit _maintainers folder

$env.NIX_CONFIG = "experimental-features = nix-command flakes\n"

let plugins_dir = "plugins"
let index_path = $"($plugins_dir)/.#index.json"

mkdir $plugins_dir

if not ($index_path | path exists) {
    mut plugins = []
    mut offset = 0
    let limit = 50
    loop {
        let url = $"https://plugins.lapce.dev/api/v1/plugins?offset=($offset)&limit=($limit)"
        let response = http get $url
        let total = $response | get total
        $offset = ($response | get offset) + $limit
        $plugins = ($plugins | append ($response | get plugins))
        if $offset >= $total {
            break
        }
    }
    $plugins = ($plugins | select author name version description repository)
    $plugins
        | sort-by author name
        | insert hash null
        | insert updated false
        | insert broken false
        | to json | save $index_path
}

loop {
    let plugins_with_no_hash = open $index_path | filter { $in.hash == null and not $in.broken }
    if $plugins_with_no_hash == [] {
        break
    }
    let plugin = $plugins_with_no_hash | first
    let author = $plugin.author
    let name = $plugin.name
    let version = $plugin.version

    let url = $"https://plugins.lapce.dev/api/v1/plugins/($author)/($name)/($version)/download"
    let url = http get $url
    let file = $"lapce-plugin-($author)-($name)-($version).tar.zstd"
    let hash = nix-prefetch-url --type sha256 --name $file $url | complete | get stdout | str trim
    let hash = (if $hash != "" {
        nix run "nixpkgs#nixVersions.nix_2_22" -- hash convert --hash-algo sha256 --from nix32 $hash
    } else { "" })

    print $"($author) ($name) ($version): ($hash)"

    open $index_path | each {
        if $in.author == $author and $in.name == $name and $in.version == $version {
            if $hash != "" {
                $in | update hash $hash
            } else {
                $in | update broken true
            }
        } else {
            $in
        }
    } | collect | sort-by author name | to json | save -f $index_path
}

loop {
    let plugins_not_updated = open $index_path | filter { not $in.updated and not $in.broken}
    if $plugins_not_updated == [] {
        break
    }
    let plugin = $plugins_not_updated | first
    let author = $plugin.author
    let name = $plugin.name
    let version = $plugin.version
    let hash = $plugin.hash
    let description = ($plugin.description | str replace --all "\"" "\\\"")

    let plugin_dir = $"($plugins_dir)/($author)/($name)"
    mkdir $plugin_dir
    [
        $"{ lapce-utils, lib }:",
        $"",
        $"lapce-utils.pluginFromRegistry {",
        $"  author = \"($author)\";",
        $"  name = \"($name)\";",
        $"  version = \"($version)\";",
        $"  hash = \"($hash)\";",
        $"  meta = {",
        $"    description = \"($description)\";",
        $"    homepage = \"https://plugins.lapce.dev/plugins/($author)/($name)\";",
        $"    maintainers = with lib.maintainers; [ timon-schelling ];",
        $"    license = with lib.licenses; [ unfreeRedistributable ];",
        $"  };",
        $"}",
        $"",
    ] | str join "\n" | save -f $"($plugin_dir)/default.nix"

    open $index_path | each {
        if $in.author == $author and $in.name == $name and $in.version == $version {
            $in | update updated true
        } else {
            $in
        }
    } | collect | sort-by author name | to json | save -f $index_path
}

let plugins_not_brocken = open $index_path | filter { not $in.broken }
if $plugins_not_brocken == [] {
    exit 0
}

let call_packages = $plugins_not_brocken | each {
    mut author = $in.author
    mut name = $in.name
    if ($author | find --regex "^[0-9].*") != null {
        $author = $"\"($author)\""
    }
    if ($name | find --regex "^[0-9].*") != null {
        $name = $"\"($name)\""
    }
    $"  ($author).($name) = callPackage ./($in.author)/($in.name) { };"
}

[
    $"{ callPackage }:",
    $"",
    $"{",
]
| append $call_packages
| append [
    $"}",
    $"",
] | str join "\n" | save -f $"($plugins_dir)/default.nix"
