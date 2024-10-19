{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, pkg-config
, autoreconfHook
, wrapGAppsHook3

, boost
, cairo
, darwin
, gettext
, glibmm
, gtk3
, gtkmm3
, libjack2
, libsigcxx
, libxmlxx
, mlt
, pango
, imagemagick
, intltool
, adwaita-icon-theme
, harfbuzz
, freetype
, fribidi
, openexr
, fftw
}:

let
  version = "1.5.1";
  src = fetchFromGitHub {
    owner = "synfig";
    repo = "synfig";
    rev = "v${version}";
    hash = "sha256-9vBYESaSgW/1FWH2uFBvPiYvxLlX0LLNnd4S7ACJcwI=";
  };

  ETL = stdenv.mkDerivation {
    pname = "ETL";
    inherit version src;

    sourceRoot = "${src.name}/ETL";

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
    ];
    buildInputs = [
      glibmm
    ];
  };

  synfig = stdenv.mkDerivation {
    pname = "synfig";
    inherit version src;

    patches = [
      # Pull upstream fix for autoconf-2.72 support:
      #   https://github.com/synfig/synfig/pull/2930
      (fetchpatch {
        name = "autoconf-2.72.patch";
        url = "https://github.com/synfig/synfig/commit/80a3386c701049f597cf3642bb924d2ff832ae05.patch";
        stripLen = 1;
        hash = "sha256-7gX8tJCR81gw8ZDyNYa8UaeZFNOx4o1Lnq0cAcaKb2I=";
      })
    ];

    sourceRoot = "${src.name}/synfig-core";

    configureFlags = [
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
    ] ++ lib.optionals stdenv.cc.isClang [
      # Newer versions of clang default to C++17, but synfig and some of its dependencies use deprecated APIs that
      # are removed in C++17. Setting the language version to C++14 allows it to build.
      "CXXFLAGS=-std=c++14"
    ];

    nativeBuildInputs = [
      pkg-config
      autoreconfHook
      gettext
      intltool
    ];
    buildInputs = [
      ETL
      boost
      cairo
      glibmm
      mlt
      libsigcxx
      libxmlxx
      pango
      imagemagick
      harfbuzz
      freetype
      fribidi
      openexr
      fftw
    ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Foundation
    ];
  };
in
stdenv.mkDerivation {
  pname = "synfigstudio";
  inherit version src;

  sourceRoot = "${src.name}/synfig-studio";

  postPatch = ''
    patchShebangs images/splash_screen_development.sh
  '';

  preConfigure = ''
    ./bootstrap.sh
  '';

  configureFlags = lib.optionals stdenv.cc.isClang [
    # Newer versions of clang default to C++17, but synfig and some of its dependencies use deprecated APIs that
    # are removed in C++17. Setting the language version to C++14 allows it to build.
    "CXXFLAGS=-std=c++14"
  ];

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    intltool
    wrapGAppsHook3
  ];
  buildInputs = [
    ETL
    synfig
    boost
    cairo
    glibmm
    gtk3
    gtkmm3
    imagemagick
    libjack2
    libsigcxx
    libxmlxx
    mlt
    adwaita-icon-theme
    openexr
    fftw
  ];

  enableParallelBuilding = true;

  passthru = {
    # Expose libraries and cli tools
    inherit ETL synfig;
  };

  meta = with lib; {
    description = "2D animation program";
    homepage = "http://www.synfig.org";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
