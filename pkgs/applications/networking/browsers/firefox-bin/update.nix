{ name
, channel
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, curl
, gnupg
, baseName ? "firefox"
, basePath ? "pkgs/applications/networking/browsers/firefox-bin"
, baseUrl
}:

let
  isBeta =
    channel != "release";

in writeScript "update-${name}" ''
  PATH=${coreutils}/bin:${gnused}/bin:${gnugrep}/bin:${xidel}/bin:${curl}/bin:${gnupg}/bin
  set -eux
  pushd ${basePath}

  HOME=`mktemp -d`
  cat ${./firefox.key} | gpg --import

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

  curl --silent -o $HOME/shasums "$url$version/SHA512SUMS"
  curl --silent -o $HOME/shasums.asc "$url$version/SHA512SUMS.asc"
  gpgv --keyring=$HOME/.gnupg/pubring.kbx $HOME/shasums.asc $HOME/shasums

  # this is a list of sha512 and tarballs for both arches
  shasums=`cat $HOME/shasums`

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

  mv $tmpfile ${channel}_sources.nix

  popd
''
