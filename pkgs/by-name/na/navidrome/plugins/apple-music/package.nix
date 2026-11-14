{
  lib,
  fetchFromGitHub,
  buildNavidromeGoPlugin,
}:

buildNavidromeGoPlugin (finalAttrs: {
  pname = "apple-music-plugin";
  bundleName = "apple-music";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "apple-music-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-45nUrIDXCtkh08TeZoc6j2BcGLQnpVJu23L56nIBN1s=";
  };

  vendorHash = "sha256-G1B6W8ZKoLuNwvOt3z5vSKcQmF2574j41A0lC+u39uI=";

  meta = {
    changelog = "https://github.com/navidrome/apple-music-plugin/releases/tag/v${finalAttrs.version}";
    description = "Fetches artist metadata from Apple Music using free iTunes/Apple Music endpoints";
    homepage = "https://github.com/navidrome/apple-music-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
