{ lib, stdenv, callPackage, fetchurl,
  guile_1_8, xmodmap, which, freetype,
  libjpeg,
  sqlite,
  texliveSmall ? null,
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
    inherit extraFonts chineseFonts japaneseFonts koreanFonts;
    tex = texliveSmall;
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

  cmakeFlags = lib.optionals stdenv.isDarwin [
    (lib.cmakeFeature "TEXMACS_GUI" "Qt")
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "./TeXmacs.app/Contents/Resources")
  ];

  env.NIX_LDFLAGS = "-lz";

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv TeXmacs.app $out/Applications/
    makeWrapper $out/Applications/TeXmacs.app/Contents/MacOS/TeXmacs $out/bin/texmacs
  '';

  qtWrapperArgs = [
    "--suffix" "PATH" ":" (lib.makeBinPath [
      xmodmap
      which
      ghostscriptX
      aspell
      texliveSmall
      git
      python3
    ])
  ];

  postFixup = lib.optionalString (!stdenv.isDarwin) ''
    wrapQtApp $out/bin/texmacs
  '';

  meta = common.meta // {
    maintainers = [ lib.maintainers.roconnor ];
    platforms = lib.platforms.all;
  };
}
