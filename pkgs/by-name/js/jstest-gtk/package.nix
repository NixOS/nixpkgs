{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  gtkmm3,
  libsigcxx,
  xorg,
}:

stdenv.mkDerivation {
  pname = "jstest-gtk";
  version = "0.1.1-unstable-2025-04-03";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "jstest-gtk";
    rev = "92bdf8e945a6d14fdd0aa6fa961f6da34f5ac810";
    sha256 = "sha256-ypGMxN0k+Y72Hjk5OKJMdc4mci38xg3DJYkboOpa/fs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    gtkmm3
    libsigcxx
    xorg.libX11
  ];

  meta = with lib; {
    description = "Simple joystick tester based on Gtk+";
    longDescription = ''
      It provides you with a list of attached joysticks, a way to display which
      buttons and axis are pressed, a way to remap axis and buttons and a way
      to calibrate your joystick.
    '';
    homepage = "https://github.com/Grumbel/jstest-gtk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.linux;
    mainProgram = "jstest-gtk";
  };
}
