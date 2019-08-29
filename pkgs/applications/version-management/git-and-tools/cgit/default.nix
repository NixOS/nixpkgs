{ stdenv, fetchurl, fetchpatch, openssl, zlib, asciidoc, libxml2, libxslt
, docbook_xsl, pkgconfig, luajit
, coreutils, gnused, groff, docutils
, gzip, bzip2, xz
, python, wrapPython, pygments, markdown
}:

stdenv.mkDerivation rec {
  name = "cgit-${version}";
  version = "1.2.1";

  src = fetchurl {
    url = "https://git.zx2c4.com/cgit/snapshot/${name}.tar.xz";
    sha256 = "1gw2j5xc5qdx2hwiwkr8h6kgya7v9d9ff9j32ga1dys0cca7qm1w";
  };

  # cgit is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump (look for "GIT_VER" in the top-level Makefile).
  gitSrc = fetchurl {
    url    = "mirror://kernel/software/scm/git/git-2.18.0.tar.xz";
    sha256 = "14hfwfkrci829a9316hnvkglnqqw1p03cw9k56p4fcb078wbwh4b";
  };

  patches = [
    (fetchpatch {
      name = "prevent-dos-limit-path-length.patch";
      url = "https://git.zx2c4.com/cgit/patch/?id=54c407a74a35d4ee9ffae94cc5bc9096c9f7f54a";
      sha256 = "1qlbpqsc293lmc9hzwf1j4jr5qlv8cm1r249v3yij5s4wki1595j";
    })
  ];

  nativeBuildInputs = [ pkgconfig ] ++ [ python wrapPython ];
  buildInputs = [
    openssl zlib asciidoc libxml2 libxslt docbook_xsl luajit
  ];
  pythonPath = [ pygments markdown ];

  postPatch = ''
    sed -e 's|"gzip"|"${gzip}/bin/gzip"|' \
        -e 's|"bzip2"|"${bzip2.bin}/bin/bzip2"|' \
        -e 's|"xz"|"${xz.bin}/bin/xz"|' \
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

    for script in $out/lib/cgit/filters/*.sh $out/lib/cgit/filters/html-converters/txt2html; do
      wrapProgram $script --prefix PATH : '${stdenv.lib.makeBinPath [ coreutils gnused ]}'
    done
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
