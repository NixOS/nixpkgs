{ stdenv, fetchurl, openssl, zlib, asciidoc, libxml2, libxslt
, docbook_xml_xslt, pkgconfig, luajit
, gzip, bzip2, xz
, python, wrapPython, pygments, markdown
}:

stdenv.mkDerivation rec {
  name = "cgit-${version}";
  version = "1.1";

  src = fetchurl {
    url = "http://git.zx2c4.com/cgit/snapshot/${name}.tar.xz";
    sha256 = "142qcgs8dwnzhymn0a7xx47p9fc2z5wrb86ah4a9iz0mpqlsz288";
  };

  # cgit is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump (look for "GIT_VER" in the top-level Makefile).
  gitSrc = fetchurl {
    url    = "mirror://kernel/software/scm/git/git-2.10.2.tar.xz";
    sha256 = "0wc64dzcxrzgi6kwcljz6y3cwm3ajdgf6aws7g58azbhvl1jk04l";
  };

  nativeBuildInputs = [ pkgconfig ] ++ [ python wrapPython ];
  buildInputs = [
    openssl zlib asciidoc libxml2 libxslt docbook_xml_xslt luajit
  ];
  pythonPath = [ pygments markdown ];

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

    wrapPythonProgramsIn "$out/lib/cgit/filters" "$out $pythonPath"
  '';

  meta = {
    homepage = https://git.zx2c4.com/cgit/about/;
    repositories.git = git://git.zx2c4.com/cgit;
    description = "Web frontend for git repositories";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ bjornfor ];
  };
}
