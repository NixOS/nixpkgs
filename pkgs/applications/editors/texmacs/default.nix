{ lib, stdenv, callPackage, fetchurl,
  guile_1_8, xmodmap, which, freetype,
  libjpeg,
  sqlite,
  tex ? null,
  aspell ? null,
  git ? null,
  python3 ? null,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  xdg-utils,
  qtbase,
  qtsvg,
  qtmacextras,
  ghostscriptX ? null,
  extraFonts ? false,
  chineseFonts ? false,
  japaneseFonts ? false,
  koreanFonts ? false }:

let
  pname = "texmacs";
  version = "2.1.2";
  common = callPackage ./common.nix {
    inherit tex extraFonts chineseFonts japaneseFonts koreanFonts;
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    hash = "sha256-Ds9gxOwMYSttEWrawgxLHGxHyMBvt8WmyPIwBP2g/CM=";
  };

  postPatch = common.postPatch + ''
    substituteInPlace configure \
      --replace "-mfpmath=sse -msse2" ""
  '';

  nativeBuildInputs = [
    guile_1_8
    pkg-config
    wrapQtAppsHook
    xdg-utils
  ] ++ lib.optionals (!stdenv.isDarwin) [
    cmake
  ];

  buildInputs = [
    guile_1_8
    qtbase
    qtsvg
    ghostscriptX
    freetype
    libjpeg
    sqlite
    git
    python3
  ] ++ lib.optionals stdenv.isDarwin [
    qtmacextras
  ];

  env.NIX_LDFLAGS = "-lz";

  qtWrapperArgs = [
    "--suffix" "PATH" ":" (lib.makeBinPath [
      xmodmap
      which
      ghostscriptX
      aspell
      tex
      git
      python3
    ])
  ];

  postFixup = ''
    wrapQtApp $out/bin/texmacs
  '';

  meta = common.meta // {
    maintainers = [ lib.maintainers.roconnor ];
    platforms = lib.platforms.all;
  };
}
