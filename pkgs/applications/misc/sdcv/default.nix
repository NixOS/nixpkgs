{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  glib,
  gettext,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "sdcv";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "Dushistov";
    repo = "sdcv";
    rev = "v${version}";
    sha256 = "sha256-EyvljVXhOsdxIYOGTzD+T16nvW7/RNx3DuQ2OdhjXJ4=";
  };

  hardeningDisable = [ "format" ];
  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    glib
    gettext
    readline
  ];

  preInstall = ''
    mkdir locale
  '';

  env.NIX_CFLAGS_COMPILE = "-D__GNU_LIBRARY__";

  meta = with lib; {
    homepage = "https://dushistov.github.io/sdcv/";
    description = "Console version of StarDict";
    maintainers = with maintainers; [ lovek323 ];
    license = licenses.gpl2;
    platforms = platforms.unix;
    mainProgram = "sdcv";
  };
}
