{ stdenv, fetchurl, openssl, zlib, asciidoc, libxml2, libxslt
, docbook_xml_xslt, pkgconfig, luajit
, gzip, bzip2, xz
}:

stdenv.mkDerivation rec {
  name = "cgit-${version}";
  version = "0.12";

  src = fetchurl {
    url = "http://git.zx2c4.com/cgit/snapshot/${name}.tar.xz";
    sha256 = "1dx54hgfyabmg9nm5qp6d01f54nlbqbbdwhwl0llb9imjf237qif";
  };

  # cgit is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump (look in the Makefile).
  # NOTE: as of 0.10.1, the git version is compatible from 1.9.0 to
  # 1.9.2 (see the repository history)
  gitSrc = fetchurl {
    url    = "mirror://kernel/software/scm/git/git-2.7.0.tar.xz";
    sha256 = "03bvb8s5j8i54qbi3yayl42bv0wf2fpgnh1a2lkhbj79zi7b77zs";
  };

  buildInputs = [
    openssl zlib asciidoc libxml2 libxslt docbook_xml_xslt pkgconfig luajit
  ];

  postPatch = ''
    sed -e 's|"gzip"|"${gzip}/bin/gzip"|' \
        -e 's|"bzip2"|"${bzip2.bin}/bin/bzip2"|' \
        -e 's|"xz"|"${xz.bin}/bin/xz"|' \
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
