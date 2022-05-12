{ pname
, channel
, writeScript
, xidel
, coreutils
, gnused
, gnugrep
, curl
, gnupg
, runtimeShell
, baseName ? "firefox"
, basePath ? "pkgs/applications/networking/browsers/firefox-bin"
, baseUrl
}:

let
  isBeta =
    channel != "release";

in writeScript "update-${pname}" ''
  #!${runtimeShell}
  PATH=${coreutils}/bin:${gnused}/bin:${gnugrep}/bin:${xidel}/bin:${curl}/bin:${gnupg}/bin
  set -eux
  pushd ${basePath}

  HOME=`mktemp -d`
  export GNUPGHOME=`mktemp -d`

  gpg --receive-keys 14F26682D0916CDD81E37B6D61B7B526D98F0353

  tmpfile=`mktemp`
  url=${baseUrl}

  # retrieve latest released version
  #  - extract all links from the $url
  #  - remove . and ..
  #  - remove everything not starting with a number
  #  - sort everything with semver in mind
  #  - remove lines that mention funnelcake
  #  - remove beta version if we are looking for the final release
  #    versions, or remove release versions if we are looking for beta
  #    versions
  # - pick the latest release
  version=`xidel -s $url --extract "//a" | \
           sed s"/.$//" | \
           grep "^[0-9]" | \
           sort --version-sort | \
           grep -v "funnelcake" | \
           grep -e "${if isBeta then "b" else ""}\([[:digit:]]\|[[:digit:]][[:digit:]]\)$" | ${if isBeta then "" else "grep -v \"b\" |"} \
           tail -1`

  curl --silent -o $HOME/shasums "$url$version/SHA256SUMS"
  curl --silent -o $HOME/shasums.asc "$url$version/SHA256SUMS.asc"
  gpgv --keyring=$GNUPGHOME/pubring.kbx $HOME/shasums.asc $HOME/shasums

  # this is a list of sha256 and tarballs for both arches
  # Upstream files contains python repr strings like b'somehash', hence the sed dance
  shasums=`cat $HOME/shasums | sed -E s/"b'([a-f0-9]{64})'?(.*)"/'\1\2'/ | grep tar.bz2`

  cat > $tmpfile <<EOF
  {
    version = "$version";
    sources = [
  EOF
  for arch in linux-x86_64 linux-i686; do
    # retrieve a list of all tarballs for each arch
    #  - only select tarballs for current arch
    #  - only select tarballs for current version
    #  - replace space with colon so that for loop doesn't
    #    intepret sha and path as 2 lines
    for line in `echo "$shasums" | \
                 grep $arch | \
                 grep "${baseName}-$version.tar.bz2$" | \
                 tr " " ":"`; do
      # create an entry for every locale
      cat >> $tmpfile <<EOF
      { url = "$url$version/`echo $line | cut -d":" -f3`";
        locale = "`echo $line | cut -d":" -f3 | sed "s/$arch\///" | sed "s/\/.*//"`";
        arch = "$arch";
        sha256 = "`echo $line | cut -d":" -f1`";
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
