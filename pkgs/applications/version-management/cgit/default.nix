{
  lib,
  stdenv,
  fetchurl,
  openssl,
  zlib,
  asciidoc,
  libxml2,
  libxslt,
  luajit,
  docbook_xsl,
  pkg-config,
  coreutils,
  gnused,
  groff,
  docutils,
  gzip,
  bzip2,
  lzip,
  xz,
  zstd,
  python3Packages,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "cgit";
  version = "1.3";

  src = fetchurl {
    url = "https://git.zx2c4.com/cgit/snapshot/cgit-1.3.tar.xz";
    sha256 = "836b6edbc7f99e11037a8b928d609ce346ed77a55545e17fff8cea59b5b7aa42";
  };

  # cgit is tightly coupled with git and needs a git source tree to build.
  # IMPORTANT: Remember to check which git version cgit needs on every version
  # bump (look for "GIT_VER" in the top-level Makefile).
  gitSrc = fetchurl {
    url = "mirror://kernel/software/scm/git/git-2.53.0.tar.xz";
    hash = "sha256-WBi9fYCwYbu9/sikM9YJ3IgYoFmR9zH/xKVh4soYxlM=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    pkg-config
    asciidoc
  ]
  ++ (with python3Packages; [
    python
    wrapPython
  ]);
  buildInputs = [
    openssl
    zlib
    libxml2
    libxslt
    luajit
    docbook_xsl
  ];
  pythonPath = with python3Packages; [
    pygments
    markdown
  ];

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

  postInstall = ''
    # Install manpage.
    make install-man $makeFlags

    wrapPythonProgramsIn "$out/lib/cgit/filters" "$out ''${pythonPath[*]}"

    for script in $out/lib/cgit/filters/*.sh $out/lib/cgit/filters/html-converters/txt2html; do
      wrapProgram $script --prefix PATH : '${
        lib.makeBinPath [
          coreutils
          gnused
        ]
      }'
    done
  '';

  stripDebugList = [ "cgit" ];

  enableParallelBuilding = true;

  passthru.tests = { inherit (nixosTests) cgit; };

  meta = {
    homepage = "https://git.zx2c4.com/cgit/about/";
    description = "Web frontend for git repositories";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bjornfor
      qyliss
      sternenseemann
    ];
  };
}
