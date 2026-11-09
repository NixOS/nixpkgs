{
  lib,
  fetchFromGitHub,
  buildNavidromeRustPlugin,
}:

buildNavidromeRustPlugin (finalAttrs: {
  pname = "lyrics-plugin";
  bundleName = "nd-lyrics";
  version = "9.2.0";

  src = fetchFromGitHub {
    owner = "J0R6IT0";
    repo = "navidrome-lyrics-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5VSgNxjHLiXWdnWHpAmSKC5WSRsrV3XfT4Pqj3VRPfs=";
  };

  cargoHash = "sha256-p1cv18z+Bgqz7Z7DHFv2bJ2VdTVInfi7bDIO5pqp2X8=";

  meta = {
    changelog = "https://github.com/J0R6IT0/navidrome-lyrics-plugin/releases/tag/v${finalAttrs.version}";
    description = "Fetches lyrics from various sources";
    homepage = "https://github.com/J0R6IT0/navidrome-lyrics-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
