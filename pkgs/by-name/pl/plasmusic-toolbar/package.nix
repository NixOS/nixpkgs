{
  lib,
  stdenv,
  fetchFromGitHub,
  kdePackages,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plasmusic-toolbar";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "ccatterina";
    repo = "plasmusic-toolbar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tZ2xcoGZp2GWoKd4XjO2K4he3tKBHgxi0PdqY+5ULn0=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/plasmusic-toolbar
    cp -r src/* $out/share/plasma/plasmoids/plasmusic-toolbar
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "KDE Plasma widget that shows currently playing song information and provide playback controls.";
    homepage = "https://github.com/ccatterina/plasmusic-toolbar";
    changelog = "https://github.com/ccatterina/plasmusic-toolbar/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
