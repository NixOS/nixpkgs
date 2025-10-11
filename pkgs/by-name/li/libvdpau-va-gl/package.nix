{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libX11,
  libpthreadstubs,
  libXau,
  libXdmcp,
  libXext,
  libvdpau,
  glib,
  libva,
  libGLU,
}:

stdenv.mkDerivation {
  pname = "libvdpau-va-gl";
  version = "0.4.2-unstable-2025-05-18";

  src = fetchFromGitHub {
    owner = "i-rinat";
    repo = "libvdpau-va-gl";
    rev = "a845e8720d900e4bcc89e7ee16106ce63b44af0d";
    hash = "sha256-CtpyWod+blqC3u12MaQyqFOXurCP5Rb2PYq7PoaoASA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libX11
    libpthreadstubs
    libXau
    libXdmcp
    libXext
    libvdpau
    glib
    libva
    libGLU
  ];

  doCheck = false; # fails. needs DRI access

  meta = with lib; {
    homepage = "https://github.com/i-rinat/libvdpau-va-gl";
    description = "VDPAU driver with OpenGL/VAAPI backend";
    license = licenses.lgpl3;
    platforms = platforms.linux;
    maintainers = [ lib.maintainers.johnrtitor ];
  };
}
