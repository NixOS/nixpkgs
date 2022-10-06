#!/usr/bin/env nix-shell
#!nix-shell -i tclsh -p tcl tcllib curl

# Generate a nix description of all packages in Minetest's ContentDB.
# See pkgs/games/minetest/packages/contentdb/README.md
# for more info about this script

package require Tcl 8.6
package require Thread 2.8
package require cmdline 1.5
package require dicttool 1.1

# TODO add base_url and user agent
set options {
  {j.arg 1 "Max jobs to run in parallel. Larger values may cause rate limiting."}
  {offline "Don't fetch new packages, just rebuild the .nix file from the cache."}
  {cache.arg "pkgs/games/minetest/packages/contentdb/cache.tcl" "Cache file to use"}
  {output.arg "pkgs/games/minetest/packages/contentdb/default.nix" "File to"}
}

try {
  array set params [::cmdline::getoptions argv $options "\[-j NUM\]\noptions:"]
} trap {CMDLINE USAGE} {msg o} {
  puts stderr $msg
  exit 2
}

# Stuff that's used in worker threads
set lib {
  package require http 2.9
  package require json 1.3

  set base_url "https://content.minetest.net"
  set user_agent "nixpkgs minetest mods updater https://github.com/NixOS/nixpkgs/blob/master/pkgs/games/minetest/packages/contentdb/README.md"


  proc fetchjson_with_backoff {backoff url} {
    global user_agent
    try {
      json::json2dict [exec -ignorestderr curl --silent --fail --show-error -A $user_agent -L $url]
    } trap CHILDSTATUS {results options} {
      # If it's not 200 OK, wait and retry
      # TODO fail on 4xx errors except error 429 Too Many Requests
      if {[lindex [dict get $options -errorcode] 2] == 22} then {
        after $backoff
        tailcall fetchjson_with_backoff [expr $backoff * 2] $url
      } else {
        error "Fetch failure"
      }
    }
  }
  proc fetchjson url {fetchjson_with_backoff 2000 $url}

  proc build_package_path {author pname} {
    string cat packages/ [::http::quoteString $author] / [::http::quoteString $pname]
  }
  proc build_src {author pname version_id} {
    global base_url
    string cat "$base_url/[build_package_path $author $pname]/releases/$version_id/download/"
  }

  proc fetch_package {author pname version_id} {
    global base_url
    # packages/user_name/pkg_name
    set package_path [build_package_path $author $pname]
    puts stderr "Fetching $author/$pname..."

    # Fetch metadata
    set meta [fetchjson "$base_url/api/$package_path"]
    set release [fetchjson "$base_url/api/$package_path/releases/$version_id"]
    set licenses [
      lsort -unique [list [dict get $meta license] [dict get $meta media_license]]
    ]

    # Fetch and hash package
    set src [build_src $author $pname $version_id]
    puts stderr $src
    # NOTE: we don't use --unpack (and fetchzip in fetchFromContentDB) because
    # of this nix bug: https://github.com/NixOS/nix/issues/4499
    # For example this package triggers it:
    # https://content.minetest.net/packages/D00Med/vehicles/releases/13681/download/
    set hash [exec -ignorestderr nix-prefetch-url --type sha256 $src]

    # Return new cache entry
    list [list $author $pname] [dict create \
      version_id $version_id \
      version [dict get $release title] \
      type [dict get $meta type] \
      hash $hash \
      licenses $licenses \
      description [dict get $meta short_description] \
      homepage [dict get $meta website]
    ]
  }
}
eval $lib

# Read cache file
if {[file exists $params(cache)]} then {
  set cachech [open $params(cache)]
  set old_cache [read $cachech]
  close $cachech
} else {
  set old_cache [dict create]
}

if {$params(offline)} then {
  set new_cache $old_cache
} else {
  set new_cache [dict create]

  # Get package list
  set packages [fetchjson https://content.minetest.net/api/packages?fmt=short]

  # Get new package data in parallel
  set pool [tpool::create -minworkers $params(j) -maxworkers $params(j) -initcmd $lib]
  set jobs [list]
  foreach p $packages {
    set package_id [list [dict get $p author] [dict get $p name]]
    if {
      [dict exists $old_cache $package_id] &&
      [dict get [dict get $old_cache $package_id] version_id] == [dict get $p release]
    } then {
      dict set new_cache $package_id [dict get $old_cache $package_id]
    } else {
      lappend jobs [tpool::post -nowait $pool [
        list fetch_package [dict get $p author] [dict get $p name] [dict get $p release]
      ]]
    }
  }
  set jobs_ $jobs
  while {[llength $jobs] > 0} {
    puts stderr [string cat "Jobs remaining: " [llength $jobs]]
    tpool::wait $pool $jobs jobs
  }
  foreach j $jobs_ {
    set result [tpool::get $pool $j]
    dict set new_cache [lindex $result 0] [lindex $result 1]
  }
}

# Get better diffs by sorting the packages
set new_cache [lsort -stride 2 $new_cache]

# Make a string suitable for use in store paths
# Simpler version of sanitizeDerivationName
proc sanitize_drv str {
  regsub -all {[^A-Za-z0-9_\-.]} $str "_"
}

# Make a string suitable for use between quotes
proc sanitize_str str {
  set str [regsub -all "\"" $str "\\\""]
  set str [regsub -all {\\} $str "\\\\"]
  set str [regsub -all "$\{" $str "$$\{"]
  regsub -all {\s+} $str " "
}

# subst may generate lines consisting of spaces only.
# When nixpkgs will be autoformatted, change this to run the formatter instead.
proc remove_stray_spaces str {
  join [lmap line [split $str "\n"] {regsub {^\s+$} $line ""}] "\n"
}

# Build nix strings
set nix_packages [dict values [dict map {package_id p} $new_cache {dict with p {
  set author [lindex $package_id 0]
  set pname [lindex $package_id 1]
  set licenses [lmap l $licenses {
    switch $l {
      "Other (Free/Open)"       {string cat "lib.licenses.free"  }
      "Other (Non-free/Closed)" {string cat "lib.licenses.unfree"}
      default                   {string cat "spdx.\"$l\""        }
    }
  }]
  subst {
    "[sanitize_drv $author]"."[sanitize_drv $pname]" = buildMinetestPackage rec {
      type = "$type";
      pname = "[sanitize_drv $pname]";
      version = "[sanitize_drv $version]";
      src = fetchFromContentDB {
        author = "[sanitize_str $author]";
        technicalName = "[sanitize_str $pname]";
        release = $version_id;
        versionName = "[sanitize_str $version]";
        sha256 = "$hash";
      };
      meta = src.meta // {
        license = \[ [join $licenses] \];
        description = "[sanitize_str $description]";
        [if {$homepage != "null"} then {subst {
          homepage = "[sanitize_str $homepage]";
        }}]
      };
    };
  }
}}]]

set cachech [open $params(cache) w]
puts $cachech $new_cache
# Or prettyprinted: (FIXME this mangles the descriptions -- need a max level)
#puts $cachech [dict print $new_cache]
# Or json (requires tcllib 1.21) (slower)
#puts $cachech [json::write object {*}[dict map {k v} $new_cache {json::write object-strings {*}$v}]]
close $cachech

set outputch [open $params(output) w]
puts $outputch [remove_stray_spaces [subst {
# Automatically generated with maintainers/scripts/update-minetest-packages.tcl
# DO NOT EDIT

{ lib, buildMinetestPackage, fetchFromContentDB }:

let spdx = lib.listToAttrs
  (lib.filter (attr: attr.name != null)
    (lib.mapAttrsToList (n: l: lib.nameValuePair (l.spdxId or null) l)
      lib.licenses));

in {
  [join $nix_packages]
}
}]]
