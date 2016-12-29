{ name
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, curl
, ed
, sourceSectionRegex ? "${name}-unwrapped = common"
, basePath ? "pkgs/applications/networking/browsers/firefox"
, baseUrl ? "http://archive.mozilla.org/pub/firefox/releases/"
, versionSuffix ? ""
}:

let
  version = (builtins.parseDrvName name).version;
in writeScript "update-${name}" ''
  PATH=${coreutils}/bin:${gnused}/bin:${gnugrep}/bin:${xidel}/bin:${curl}/bin:${ed}/bin

  pushd ${basePath}

  url=${baseUrl}

  # retriving latest released version
  #  - extracts all links from the $url
  #  - extracts lines only with number and dots followed by a slash
  #  - removes trailing slash
  #  - sorts everything with semver in mind
  #  - picks up latest release
  version=`xidel -q $url --extract "//a" | \
           grep "^[0-9.]*${versionSuffix}/$" | \
           sed s/[/]$// | \
           sort --version-sort | \
           tail -n 1`

  shasum=`curl --silent $url$version/SHA512SUMS | grep 'source\.tar\.xz' | cut -d ' ' -f 1`

  ed default.nix <<COMMANDS
  # search line
    /${sourceSectionRegex}/
  # search version number line
    /version/
  # update the version
    s/".*"/"$version"/
  # search hash line
    /sha512/
  # update the hash
    s/".*"/"$shasum"/
  # write then quit
    wq
  COMMANDS

  popd
''
