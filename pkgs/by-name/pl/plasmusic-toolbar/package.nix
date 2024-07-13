{ lib
, stdenv
, fetchFromGitHub
, kdePackages
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plasmusic-toolbar";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "ccatterina";
    repo = "plasmusic-toolbar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7c+7l9/xg112SVDUqNi12fg6unq6qE6xmMwIrEJk6PQ=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plasma/plasmoids/plasmusic-toolbar
    cp -r src/* $out/share/plasma/plasmoids/plasmusic-toolbar
    runHook postInstall
  '';

  meta = {
    description = "KDE Plasma widget that shows currently playing song information and provide playback controls.";
    homepage = "https://github.com/ccatterina/plasmusic-toolbar";
    changelog = "https://github.com/ccatterina/plasmusic-toolbar/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
