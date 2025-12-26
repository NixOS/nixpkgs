{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  freetype,
  giflib,
  gtk3,
  lcms2,
  libjpeg,
  libpng,
  libtiff,
  openjpeg,
  gifsicle,
  gettext,
}:

stdenv.mkDerivation {
  pname = "mtPaint";
  version = "3.50.12";

  src = fetchFromGitHub {
    owner = "wjaguar";
    repo = "mtPaint";
    rev = "7cae5d663ed835a365d89a535536c39e18862a83";
    hash = "sha256-W/MQZ1WqoVMzyEd60rbvA8yieesDc/xfKqbYGZumi2U=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    gettext
  ];

  buildInputs = [
    freetype
    giflib
    gtk3
    lcms2
    libjpeg
    libpng
    libtiff
    openjpeg
    gifsicle
  ];

  configureFlags = [
    "gtk3"
    "intl"
    "man"
  ];

  meta = {
    description = "Simple GTK painting program";
    longDescription = ''
      mtPaint is a simple GTK painting program designed for
      creating icons and pixel based artwork.  It can edit indexed palette
      or 24 bit RGB images and offers basic painting and palette manipulation
      tools. It also has several other more powerful features such as channels,
      layers and animation.
      Due to its simplicity and lack of dependencies it runs well on
      GNU/Linux, Windows and older PC hardware.
    '';
    homepage = "https://mtpaint.sourceforge.net/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "mtpaint";
  };
}
