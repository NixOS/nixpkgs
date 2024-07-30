{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  meson,
  cmake,
  pkg-config,
  dbus,
  ninja,
}:

stdenv.mkDerivation {
  pname = "iio-hyprland";
  version = "0-unstable-2023-09-27";

  src = fetchFromGitHub {
    owner = "JeanSchoeller";
    repo = "iio-hyprland";
    rev = "f31ee4109379ad7c3a82b1a0aef982769e482faf";
    hash = "sha256-P+m2OIVS8QSQmeVYVIgt2A6Q/I3zZX3bK9UNLyQtNOg=";
  };

  patches = [
    # fix rotation of touch and tablet not working
    (fetchpatch {
      name = "keyword.patch";
      url = "https://github.com/JeanSchoeller/iio-hyprland/commit/f13242bbdf4a0d062683bf23b2431bb72e2e6ab9.diff";
      hash = "sha256-lp5wmvL+F209FAdEdrmvPkYWi2ZzJq+2jrpGdFlolqQ=";
    })
  ];

  buildInputs = [ dbus ];
  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
  ];

  meta = with lib; {
    description = "Listens to iio-sensor-proxy and automatically changes Hyprland output orientation";
    homepage = "https://github.com/JeanSchoeller/iio-hyprland/tree/master";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ yusuf-duran ];
    platforms = platforms.linux;
    mainProgram = "iio-hyprland";
  };
}
