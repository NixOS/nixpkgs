{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, wrapQtAppsHook
, qtbase
, libpng
, giflib
, libjpeg
, impy
}:

stdenv.mkDerivation rec {
  pname = "evilpixie";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "bcampbell";
    repo = "evilpixie";
    rev = "v${version}";
    sha256 = "sha256-+DdAN+xDOYxLgLHUlr75piTEPrWpuOyXvxckhBEl7yU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    libpng
    giflib
    libjpeg
    impy
  ];

  meta = with lib; {
    description = "Pixel-oriented paint program, modelled on Deluxe Paint";
    homepage = "https://github.com/bcampbell/evilpixie"; # http://evilpixie.scumways.com/ is gone
    downloadPage = "https://github.com/bcampbell/evilpixie/releases";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
    # Undefined symbols for architecture x86_64:
    # "_bundle_path", referenced from: App::SetupPaths() in src_app.cpp.o
    broken = stdenv.isDarwin ||
    # https://github.com/bcampbell/evilpixie/issues/28
      stdenv.isAarch64;
  };
}

