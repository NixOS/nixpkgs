{ lib, stdenv, fetchurl, openssl, zlib, asciidoc, libxml2, libxslt
, docbook_xsl, pkg-config, luajit
, coreutils, gnused, groff, docutils
, gzip, bzip2, lzip, xz, zstd
, python, wrapPython, pygments, markdown
}:

stdenv.mkDerivation rec {
  pname = "cgit";
  version = "1.2.3";

  src = fetchurl {
    url = "https://git.zx2c4.com/cgit/snapshot/${pname}-${version}.tar.xz";
    sha256 = "193d990ym10qlslk0p8mjwp2j6rhqa7fq0y1iff65lvbyv914pss";
  };

  # cgit is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump (look for "GIT_VER" in the top-level Makefile).
  gitSrc = fetchurl {
    url    = "mirror://kernel/software/scm/git/git-2.25.1.tar.xz";
    sha256 = "09lzwa183nblr6l8ib35g2xrjf9wm9yhk3szfvyzkwivdv69c9r2";
  };

  nativeBuildInputs = [ pkg-config asciidoc ] ++ [ python wrapPython ];
  buildInputs = [
    openssl zlib libxml2 libxslt docbook_xsl luajit
  ];
  pythonPath = [ pygments markdown ];

  postPatch = ''
    sed -e 's|"gzip"|"${gzip}/bin/gzip"|' \
        -e 's|"bzip2"|"${bzip2.bin}/bin/bzip2"|' \
        -e 's|"lzip"|"${lzip}/bin/lzip"|' \
        -e 's|"xz"|"${xz.bin}/bin/xz"|' \
        -e 's|"zstd"|"${zstd}/bin/zstd"|' \
        -i ui-snapshot.c

    substituteInPlace filters/html-converters/man2html \
      --replace 'groff' '${groff}/bin/groff'

    substituteInPlace filters/html-converters/rst2html \
      --replace 'rst2html.py' '${docutils}/bin/rst2html.py'
  '';

  # Give cgit a git source tree and pass configuration parameters (as make
  # variables).
  preBuild = ''
    mkdir -p git
    tar --strip-components=1 -xf "$gitSrc" -C git
  '';

  makeFlags = [
    "prefix=$(out)"
    "CGIT_SCRIPT_PATH=$(out)/cgit/"
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
  ];

  # Install manpage.
  postInstall = ''
    # xmllint fails:
    #make install-man

    # bypassing xmllint works:
    a2x --no-xmllint -f manpage cgitrc.5.txt
    mkdir -p "$out/share/man/man5"
    cp cgitrc.5 "$out/share/man/man5"

    wrapPythonProgramsIn "$out/lib/cgit/filters" "$out $pythonPath"

    for script in $out/lib/cgit/filters/*.sh $out/lib/cgit/filters/html-converters/txt2html; do
      wrapProgram $script --prefix PATH : '${lib.makeBinPath [ coreutils gnused ]}'
    done
  '';

  stripDebugList = [ "cgit" ];

  meta = {
    homepage = "https://git.zx2c4.com/cgit/about/";
    repositories.git = "git://git.zx2c4.com/cgit";
    description = "Web frontend for git repositories";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bjornfor ];
  };
}
