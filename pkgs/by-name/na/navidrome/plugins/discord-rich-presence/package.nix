{
  lib,
  pkgs,
  buildNavidromePlugin,
}:
buildNavidromePlugin rec {
  pname = "discord-rich-presence-plugin";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "navidrome";
    repo = "discord-rich-presence-plugin";
    tag = "v${version}";
    hash = "sha256-YH1K6uagIloQQ4gdezKMAfx9KbGL9chiTx/i8CiH4io=";
  };

  vendorHash = "sha256-M5dI0gNfy2x9IVN1284pdvUaCui0sgxFCC+9weq2ipM=";

  meta = {
    description = "Displays your currently playing track in your Discord status";
    homepage = "https://github.com/navidrome/discord-rich-presence-plugin";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
}
