{
  lib,
  fetchFromGitHub,
  buildNavidromeGoPlugin,
}:
buildNavidromeGoPlugin (finalAttrs: {
  pname = "discord-rich-presence-plugin";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "navidrome";
    repo = "discord-rich-presence-plugin";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j4iGymXH9JstPGdpPl5TFLiH8ShfE46U+BZk1n7a2yQ=";
  };

  vendorHash = "sha256-5ZlqyUa+UcLCBdLQaYAlb818Y8sOENjIFfb2hpRsbpQ=";

  meta = {
    changelog = "https://github.com/navidrome/discord-rich-presence-plugin/releases/tag/v${finalAttrs.version}";
    description = "Displays your currently playing track in your Discord status";
    homepage = "https://github.com/navidrome/discord-rich-presence-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
