{ writeScript
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
}:

writeScript "update-${attrPath}" ''
  PATH=${lib.makeBinPath [ common-updater-scripts coreutils curl gnugrep gnused xidel ]}

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

  update-source-version ${attrPath} "$version" "$shasum"
''
