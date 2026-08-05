{
  lib,
  pkgs,
  buildNavidromePlugin,
}:
buildNavidromePlugin rec {
  pname = "discord-rich-presence-plugin";
  version = "2.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "navidrome";
    repo = "discord-rich-presence-plugin";
    tag = "v${version}";
    hash = "sha256-j4iGymXH9JstPGdpPl5TFLiH8ShfE46U+BZk1n7a2yQ=";
  };

  vendorHash = "sha256-5ZlqyUa+UcLCBdLQaYAlb818Y8sOENjIFfb2hpRsbpQ=";

  meta = {
    description = "Displays your currently playing track in your Discord status";
    homepage = "https://github.com/navidrome/discord-rich-presence-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
