{ lib
, stdenv
, fetchFromGitHub
, kdePackages
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "plasmusic-toolbar";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "ccatterina";
    repo = "plasmusic-toolbar";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rThoh7NkpWlKUNOsAY9WEt1F1MFoKliNYCB9ySfKYy8=";
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
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ HeitorAugustoLN ];
    inherit (kdePackages.kwindowsystem.meta) platforms;
  };
})
