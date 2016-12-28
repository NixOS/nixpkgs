{ name
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, curl
, baseName ? "firefox"
, basePath ? "pkgs/applications/networking/browsers/firefox-bin" 
, baseUrl ? "http://archive.mozilla.org/pub/firefox/releases/"
}:

let
  version = (builtins.parseDrvName name).version;
  isBeta = builtins.stringLength version + 1 == builtins.stringLength (builtins.replaceStrings ["b"] ["bb"] version);
in writeScript "update-${baseName}-bin" ''
  PATH=${coreutils}/bin:${gnused}/bin:${gnugrep}/bin:${xidel}/bin:${curl}/bin

  pushd ${basePath}

  tmpfile=`mktemp`
  url=${baseUrl}

  # retriving latest released version
  #  - extracts all links from the $url
  #  - removes . and ..
  #  - this line remove everything not starting with a number
  #  - this line sorts everything with semver in mind
  #  - we remove lines that are mentioning funnelcake
  #  - this line removes beta version if we are looking for final release
  #    versions or removes release versions if we are looking for beta
  #    versions
  # - this line pick up latest release
  version=`xidel -q $url --extract "//a" | \
           sed s"/.$//" | \
           grep "^[0-9]" | \
           sort --version-sort | \
           grep -v "funnelcake" | \
           grep -e "${if isBeta then "b" else ""}\([[:digit:]]\|[[:digit:]][[:digit:]]\)$" | ${if isBeta then "" else "grep -v \"b\" |"} \
           tail -1`

  # this is a list of sha512 and tarballs for both arches
  shasums=`curl --silent $url$version/SHA512SUMS`

  cat > $tmpfile <<EOF
  {
    version = "$version";
    sources = [
  EOF
  for arch in linux-x86_64 linux-i686; do
    # retriving a list of all tarballs for each arch
    #  - only select tarballs for current arch
    #  - only select tarballs for current version
    #  - rename space with colon so that for loop doesnt
    #  - inteprets sha and path as 2 lines
    for line in `echo "$shasums" | \
                 grep $arch | \
                 grep "${baseName}-$version.tar.bz2$" | \
                 tr " " ":"`; do
      # create an entry for every locale
      cat >> $tmpfile <<EOF
      { url = "$url$version/`echo $line | cut -d":" -f3`";
        locale = "`echo $line | cut -d":" -f3 | sed "s/$arch\///" | sed "s/\/.*//"`";
        arch = "$arch";
        sha512 = "`echo $line | cut -d":" -f1`";
      }
  EOF
    done
  done
  cat >> $tmpfile <<EOF
      ];
  }
  EOF

  mv $tmpfile ${if isBeta then "beta_" else ""}sources.nix

  popd
''
