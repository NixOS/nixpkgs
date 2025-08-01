{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
  cairo,
  wayland,
  libGL,
}:
rustPlatform.buildRustPackage rec {
  pname = "enkei";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "fia0";
    repo = "enkei";
    rev = "v${version}";
    sha256 = "sha256-COU2JtiJcPRA3Jno0qLEIVgimYBWfn5Pgc1OMImsJtI=";
  };

  cargoHash = "sha256-4LgJP3xtN009rf12hOZvmqXK6iz7yn0Y4zwVSo+qEZQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    wayland
    libGL
    glib
    cairo
  ];

  doCheck = false; # no tests

  meta = with lib; {
    description = "Wallpaper daemon and control tool for Wayland";
    longDescription = ''
      Created to allow displaying dynamic wallpapers based on the specification format used for example in the `Gnome` desktop environment.
      It is designed to offer a _smooth_ transition between wallpapers and gradual change over long and short periods of time.
      For a fast handling `enkei` uses `OpenGL` to render images and blending them for transitions.
    '';
    homepage = "https://github.com/jwuensche/enkei";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ ppenguin ];
  };
}
