{
  lib,
  stdenv,
  fetchFromGitLab,
  bison,
  flex,
  makeWrapper,
  getopt,
  readline,
  texinfo,
  texlive,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eukleides";
  version = "1.5.4";

  src = fetchFromGitLab {
    # official upstream www.eukleides.org is down
    domain = "salsa.debian.org";
    owner = "georgesk";
    repo = "eukleides";
    rev = "upstream/${finalAttrs.version}";
    hash = "sha256-keX7k14X/97zHh87A/7vUsfGc/S6fByd+rewW+LkJeM=";
  };

  patches = [
    # use $CC instead of hardcoded gcc
    ./use-CC.patch
    # allow PostScript transparency in epstopdf call
    ./gs-allowpstransparency.patch
    # fix curly brace escaping in eukleides.texi for newer texinfo compatiblity
    ./texinfo-escape.patch
  ];

  nativeBuildInputs = [
    bison
    flex
    texinfo
    makeWrapper
  ];

  buildInputs = [
    getopt
    readline
  ];

  preConfigure = ''
    substituteInPlace Makefile \
      --replace-fail mktexlsr true

    substituteInPlace doc/Makefile \
      --replace-fail ginstall-info install-info

    substituteInPlace Config \
      --replace-fail '/usr/local' "$out" \
      --replace-fail '$(SHARE_DIR)/texmf' "$tex"
  '';

  # Workaround build failure on -fno-common toolchains like upstream
  # gcc-10. Otherwise build fails as:
  #   ld: eukleides_build/triangle.o:(.bss+0x28): multiple definition of `A';
  #     eukleides_build/quadrilateral.o:(.bss+0x18): first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  preBuild = ''
    mkdir build/eukleides_build
    mkdir build/euktopst_build
  '';

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    wrapProgram $out/bin/euktoeps \
      --prefix PATH : ${lib.makeBinPath [ getopt ]}
  '';

  outputs = [
    "out"
    "doc"
    "tex"
  ];

  passthru = {
    tlType = "run";
    # packages needed by euktoeps, euktopdf and eukleides.sty
    tlDeps = with texlive; [
      collection-pstricks
      epstopdf
      iftex
      moreverb
    ];
    pkgs = [ finalAttrs.finalPackage.tex ];
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "Geometry Drawing Language";
    homepage = "http://www.eukleides.org/";
    license = lib.licenses.gpl3Plus;

    longDescription = ''
      Eukleides is a computer language devoted to elementary plane
      geometry. It aims to be a fairly comprehensive system to create
      geometric figures, either static or dynamic. Eukleides allows to
      handle basic types of data: numbers and strings, as well as
      geometric types of data: points, vectors, sets (of points), lines,
      circles and conics.
    '';

    platforms = lib.platforms.unix;
  };
})
