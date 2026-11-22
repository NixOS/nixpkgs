{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libx11,
  libxrandr,
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
    libx11
    libxrandr
    linuxPackages.nvidia_x11.settings.libXNVCtrl
  ];

  meta = {
    description = "Simple library to adjust color saturation of X11 outputs";
    homepage = "https://github.com/libvibrant/libvibrant";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Scrumplex ];
    mainProgram = "vibrant-cli";
  };
})
