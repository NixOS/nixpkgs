{ stdenv, fetchurl, openssl, zlib, asciidoc, libxml2, libxslt
, docbook_xml_xslt, pkgconfig, luajit
, gzip, bzip2, xz
}:

stdenv.mkDerivation rec {
  name = "cgit-0.10.1";

  src = fetchurl {
    url = "http://git.zx2c4.com/cgit/snapshot/${name}.tar.xz";
    sha256 = "0bci1p9spf79wirc4lk36cndcx2b9wj0fq1l58rlp6r563is77l3";
  };

  # cgit is is tightly coupled with git and needs a git source tree to build.
  # The cgit-0.10 Makefile has GIT_VER = 1.8.5, so use that version.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump.
  gitSrc = fetchurl {
    url = https://git-core.googlecode.com/files/git-1.8.5.tar.gz;
    sha256 = "08vbq8y3jx1da417hkqmrkdkysac1sqjvrjmaj1v56dmkghm43w7";
  };

  buildInputs = [
    openssl zlib asciidoc libxml2 libxslt docbook_xml_xslt pkgconfig luajit
  ];

  postPatch = ''
    sed -e 's|"gzip"|"${gzip}/bin/gzip"|' \
        -e 's|"bzip2"|"${bzip2}/bin/bzip2"|' \
        -e 's|"xz"|"${xz}/bin/xz"|' \
        -i ui-snapshot.c
  '';

  # Give cgit a git source tree and pass configuration parameters (as make
  # variables).
  preBuild = ''
    mkdir -p git
    tar --strip-components=1 -xf "$gitSrc" -C git

    makeFlagsArray+=(prefix="$out" CGIT_SCRIPT_PATH="$out/cgit/")
  '';

  # Install manpage.
  postInstall = ''
    # xmllint fails:
    #make install-man

    # bypassing xmllint works:
    a2x --no-xmllint -f manpage cgitrc.5.txt
    mkdir -p "$out/share/man/man5"
    cp cgitrc.5 "$out/share/man/man5"
  '';

  meta = {
    homepage = http://git.zx2c4.com/cgit/about/;
    repositories.git = git://git.zx2c4.com/cgit;
    description = "Web frontend for git repositories";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
