{
  stdenv,
  lib,
  pkg-config,
  fetchFromGitHub,
  xorg,
  libdrm,
  SDL2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "switchres";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "antonioginer";
    repo = "switchres";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/21RcpumWYNBPck7gpH6krwC3Thz/rKDPgeJblN2BDA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    xorg.libXrandr
    xorg.xorgproto
    libdrm
    SDL2
  ];

  patchPhase = ''
    runHook prePatch

    substituteInPlace ./custom_video_xrandr.cpp \
      --replace-fail libX11.so ${xorg.libX11}/lib/libX11.so \
      --replace-fail libXrandr.so ${xorg.libXrandr}/lib/libXrandr.so

    substituteInPlace ./custom_video_drmkms.cpp \
      --replace-fail libdrm.so ${libdrm}/lib/libdrm.so \

    runHook postPatch
  '';

  env = {
    PREFIX = "$(out)";
  };

  preInstall = ''
    install -Dm755 switchres $out/bin/switchres
  '';

  meta = {
    description = "Modeline generation engine for emulation";
    homepage = "https://github.com/antonioginer/switchres";
    changelog = "https://github.com/antonioginer/switchres/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    mainProgram = "switchres";
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    platforms = lib.platforms.linux;
  };
})
