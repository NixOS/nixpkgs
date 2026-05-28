{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libdrm,
  libva,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cmrt";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "cmrt";
    rev = finalAttrs.version;
    sha256 = "sha256-W6MQI41J9CKeM1eILCkvmW34cbCC8YeEF2mE+Ci8o7s=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libdrm
    libva
  ];

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    homepage = "https://01.org/linuxmedia";
    description = "Intel C for Media Runtime";
    longDescription = "Media GPU kernel manager for Intel G45 & HD Graphics family";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tadfisher ];
    platforms = lib.platforms.linux;
  };
})
