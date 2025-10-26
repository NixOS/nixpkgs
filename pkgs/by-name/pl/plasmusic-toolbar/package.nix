{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  kdePackages,
  nix-update-script,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plasmusic-toolbar";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "ccatterina";
    repo = "plasmusic-toolbar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yCsNvco01dy72f8g1+BCYXo1yx/ERdfggLYchj/UXcw=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/plasmusic-toolbar
    cp -r src/* $out/share/plasma/plasmoids/plasmusic-toolbar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma widget that shows currently playing song information and provide playback controls";
    homepage = "https://github.com/ccatterina/plasmusic-toolbar";
    changelog = "https://github.com/ccatterina/plasmusic-toolbar/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
