{ writeScript
, stdenv
, lib
, xidel
, common-updater-scripts
, coreutils
, gnused
, gnugrep
, curl
, attrPath
, baseUrl ? "http://archive.mozilla.org/pub/firefox/releases/"
, versionSuffix ? ""
, versionKey ? "version"
}:

writeScript "update-${attrPath}" ''
  #!${stdenv.shell}
  PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep gnused xidel ]}

  url=${baseUrl}

  # retriving latest released version
  #  - extracts all links from the $url
  #  - extracts lines only with number and dots followed by a slash
  #  - removes trailing slash
  #  - sorts everything with semver in mind
  #  - picks up latest release
  version=`xidel -s $url --extract "//a" | \
           grep "^[0-9.]*${versionSuffix}/$" | \
           sed s/[/]$// | \
           sort --version-sort | \
           tail -n 1`

  update-source-version ${attrPath} "$version" "" "" ${versionKey}
''
