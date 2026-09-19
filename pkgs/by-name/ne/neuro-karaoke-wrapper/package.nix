{
  lib,
  appimageTools,
  fetchurl,
  nix-update-script,
}:
appimageTools.wrapType2 rec {
  pname = "neuro-karaoke-wrapper";
  version = "1.8.1";

  src = fetchurl {
    url = "https://github.com/AferilVT/neuro-karaoke-wrapper/releases/download/v${version}/Neuro.Karaoke.Player-x86_64.AppImage";
    hash = "sha256-2iZdZq2XkK2jlVsg1i23+9IHyV5QPNl1bxL33qk/s+E=";
  };

  meta = {
    description = "Neuro Karaoke Player";
    homepage = "https://github.com/AferilVT/neuro-karaoke-wrapper";
    changelog = "https://github.com/AferilVT/neuro-karaoke-wrapper/releases/tag/v${version}";
    license = lib.licenses.gpl3;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = [ lib.maintainers.semka612 ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "neuro-karaoke-wrapper";
  };
  passthru.updateScript = nix-update-script { };
}
