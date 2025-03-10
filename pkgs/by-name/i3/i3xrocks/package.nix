{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  pkg-config,
  xcbutilxrm,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "i3xrocks";
  version = "1.3.6-1";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "i3xrocks";
    rev = "v${version}";
    hash = "sha256-qZWuYRwgSNVURxaZDzBU6yUcpIMUeGZg3HXlI8KzyX4=";
  };

  buildInputs = [
    autoconf
    automake
    pkg-config
    xcbutilxrm
    xorg.xcbutil
  ];

  configurePhase = ''
    ./autogen.sh
    ./configure --prefix=$out
  '';

  buildPhase = ''
    make
  '';

  meta = {
    description = "A fork of i3blocks that can read Xresources";
    homepage = "https://github.com/regolith-linux/i3xrocks";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sandptel ];
    mainProgram = "i3xrocks";
    platforms = lib.platforms.linux;
  };
}
