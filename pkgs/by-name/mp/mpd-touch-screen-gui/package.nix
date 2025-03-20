{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  autoreconfHook,
  SDL2,
  SDL2_ttf,
  SDL2_image,
  boost,
  libmpdclient,
  libwtk-sdl2,
  icu,
  libconfig,
  dejavu_fonts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mpd-touch-screen-gui";
  version = "unstable-2022-12-30";

  src = fetchFromGitHub {
    owner = "muesli4";
    repo = "mpd-touch-screen-gui";
    rev = "156eaebede89da2b83a98d8f9dfa46af12282fb4";
    sha256 = "sha256-vr/St4BghrndjUQ0nZI/uJq+F/MjEj6ulc4DYwQ/pgU=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  postPatch = ''
    sed -i s#/usr/share/fonts/TTF#${dejavu_fonts}/share/fonts/truetype#g data/program.conf
  '';

  buildInputs = [
    SDL2
    SDL2_ttf
    SDL2_image
    boost
    libmpdclient
    libwtk-sdl2
    icu
    libconfig
  ];

  # https://stackoverflow.com/questions/53089494/configure-error-could-not-find-a-version-of-the-library
  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Small MPD client that let's you view covers and has controls suitable for small touchscreens";
    homepage = "https://github.com/muesli4/mpd-touch-screen-gui";
    # See: https://github.com/muesli4/mpd-touch-screen-gui/tree/master/LICENSES
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ doronbehar ];
    platforms = platforms.all;
  };
})
