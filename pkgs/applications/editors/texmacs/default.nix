{
  lib,
  stdenv,
  callPackage,
  fetchurl,
  gnutls,
  guile_1_8,
  xmodmap,
  which,
  freetype,
  libjpeg,
  sqlite,
  texliveSmall ? null,
  aspell ? null,
  git ? null,
  python3 ? null,
  cmake,
  pkg-config,
  xdg-utils,
  qt6,
  ghostscriptX ? null,
  extraFonts ? false,
  chineseFonts ? false,
  japaneseFonts ? false,
  koreanFonts ? false,
}:

let
  pname = "texmacs";
  version = "2.1.5";
  common = callPackage ./common.nix {
    inherit
      extraFonts
      chineseFonts
      japaneseFonts
      koreanFonts
      ;
    tex = texliveSmall;
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://www.texmacs.org/Download/ftp/tmftp/source/TeXmacs-${version}-src.tar.gz";
    hash = "sha256-s6EnvbqOeQELI5KRQVy+NDEzNSHiRHeoFLWG4bQCc2A=";
  };

  postPatch = common.postPatch + ''
    substituteInPlace configure \
      --replace-fail "-mfpmath=sse -msse2" ""
  '';

  nativeBuildInputs = [
    guile_1_8
    pkg-config
    qt6.wrapQtAppsHook
    xdg-utils
    cmake
  ];

  buildInputs = [
    gnutls
    guile_1_8
    qt6.qtbase
    qt6.qtsvg
    qt6.qt5compat
    ghostscriptX
    freetype
    libjpeg
    sqlite
    git
    python3
  ];

  cmakeFlags = [
    (lib.cmakeFeature "TEXMACS_GUI" "Qt6")
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "./TeXmacs.app/Contents/Resources")
  ];

  env.NIX_LDFLAGS = "-lz";

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv TeXmacs.app $out/Applications/
    makeWrapper $out/Applications/TeXmacs.app/Contents/MacOS/TeXmacs $out/bin/texmacs
  '';

  qtWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    (lib.makeBinPath [
      xmodmap
      which
      ghostscriptX
      aspell
      texliveSmall
      git
      python3
    ])
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--set"
    "TEXMACS_PATH"
    "${placeholder "out"}/Applications/TeXmacs.app/Contents/Resources/share/TeXmacs"
  ];

  postFixup = lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    wrapQtApp $out/bin/texmacs
  '';

  meta = common.meta // {
    maintainers = [ lib.maintainers.roconnor ];
    platforms = lib.platforms.all;
  };
}
