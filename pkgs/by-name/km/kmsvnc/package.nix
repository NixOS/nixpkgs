{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libdrm,
  libvncserver,
  libxkbcommon,
  libva,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kmsvnc";
  version = "0.0.6";

  src = fetchFromGitHub {
    owner = "isjerryxiao";
    repo = "kmsvnc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fOryY9pkeRXjfOq4ZcUKBrBDMWEljLChwXSAbeMNXhw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libdrm
    libvncserver
    libxkbcommon
    libva
  ];

  meta = {
    description = "VNC server for DRM/KMS capable GNU/Linux devices";
    homepage = "https://github.com/isjerryxiao/kmsvnc";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nickcao ];
    mainProgram = "kmsvnc";
    platforms = lib.platforms.linux;
  };
})
