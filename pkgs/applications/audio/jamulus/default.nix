{ mkDerivation
, lib
, fetchFromGitHub
, pkg-config
, qtscript
, qmake
, qtbase
, qtmultimedia
, qtdeclarative
, libjack2
}:

mkDerivation rec {
  pname = "jamulus";
  version = "3.10.0";
  src = fetchFromGitHub {
    owner = "jamulussoftware";
    repo = "jamulus";
    rev = "r${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-uqBre1Hcdmmifm/gii3MlP9LiAovQVsAaPZTmVm1nnM=";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [
    qtscript
    qtbase
    qtmultimedia
    qtdeclarative
    libjack2
  ];

  qmakeFlags = [ "CONFIG+=noupcasename" ];

  meta = {
    description = "Enables musicians to perform real-time jam sessions over the internet";
    longDescription = "You also need to enable JACK and should enable several real-time optimizations. See project website for details";
    homepage = "https://github.com/corrados/jamulus/wiki";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "jamulus";
    maintainers = [ lib.maintainers.seb314 ];
  };
}
