{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, wrapGAppsHook

, boost
, cairo
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
, gnome
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

<<<<<<< HEAD
    sourceRoot = "${src.name}/ETL";
=======
    sourceRoot = "source/ETL";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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

<<<<<<< HEAD
    sourceRoot = "${src.name}/synfig-core";
=======
    sourceRoot = "source/synfig-core";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    configureFlags = [
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
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
    ];
  };
in
stdenv.mkDerivation {
  pname = "synfigstudio";
  inherit version src;

<<<<<<< HEAD
  sourceRoot = "${src.name}/synfig-studio";
=======
  sourceRoot = "source/synfig-studio";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postPatch = ''
    patchShebangs images/splash_screen_development.sh
  '';

  preConfigure = ''
    ./bootstrap.sh
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    gettext
    intltool
    wrapGAppsHook
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
    gnome.adwaita-icon-theme
    openexr
    fftw
  ];

  enableParallelBuilding = true;

  passthru = {
    # Expose libraries and cli tools
    inherit ETL synfig;
  };

  meta = with lib; {
    description = "A 2D animation program";
    homepage = "http://www.synfig.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
