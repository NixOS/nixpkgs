{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  blend2d,
  libxkbcommon,
  ffmpeg,
  pipewire,
  basu,
  systemd,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  copyDesktopItems,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scran";
  version = "0.8.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "iciclejj";
    repo = "scran";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jDCyjP3BdldZXOj7Dz+TCGb4RA0fBjxy2fdEMfBz7H8=";
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];

  buildInputs = [
    wayland-scanner
    wayland-protocols
    wayland
    blend2d
    libxkbcommon
    ffmpeg
    pipewire
    (if systemdSupport then systemd else basu)
  ];

  buildType = "release";
  buildFlags = [ finalAttrs.buildType ];

  installPhase = ''
    runHook preInstall
    install -D build/${finalAttrs.buildType}/scran $out/bin/scran
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "scran";
      exec = "scran";
      desktopName = "Scran";
      genericName = "Screen Capture";
      categories = [
        "Utility"
        "Graphics"
      ];
    })
  ];

  meta = {
    description = "Sway screen capture";
    mainProgram = "scran";
    license = lib.licenses.mit;
    homepage = "https://github.com/iciclejj/scran";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      iciclejj
    ];
  };
})
