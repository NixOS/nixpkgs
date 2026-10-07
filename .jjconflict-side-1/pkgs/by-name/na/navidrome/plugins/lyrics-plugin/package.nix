{
  lib,
  fetchFromGitHub,
  buildNavidromeRustPlugin,
}:

buildNavidromeRustPlugin (finalAttrs: {
  pname = "lyrics-plugin";
  bundleName = "nd-lyrics";
  version = "8.1.0";

  src = fetchFromGitHub {
    owner = "J0R6IT0";
    repo = "navidrome-lyrics-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VSy8W1kkAIk+xidd7fCMmhlvnadF7vXOPRtPNNMXu3s=";
  };

  cargoHash = "sha256-TWI0u0oXj4/OdsXut2HXitGt0UmBcUUfOfhR1pkgW54=";

  meta = {
    changelog = "https://github.com/J0R6IT0/navidrome-lyrics-plugin/releases/tag/v${finalAttrs.version}";
    description = "Fetches lyrics from various sources";
    homepage = "https://github.com/J0R6IT0/navidrome-lyrics-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
