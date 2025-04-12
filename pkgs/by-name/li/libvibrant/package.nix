{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libX11,
  libXrandr,
  linuxPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libvibrant";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "libvibrant";
    repo = "libvibrant";
    rev = finalAttrs.version;
    hash = "sha256-APja211+U0WVuCRz8f3VIAQLF4oPhh0CJ3Y5EgSJnh0=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    libX11
    libXrandr
    linuxPackages.nvidia_x11.settings.libXNVCtrl
  ];

  meta = with lib; {
    description = "Simple library to adjust color saturation of X11 outputs";
    homepage = "https://github.com/libvibrant/libvibrant";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ Scrumplex ];
    mainProgram = "vibrant-cli";
  };
})
