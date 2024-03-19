{ lib
, buildLua
, fetchFromGitHub
, gitUpdater
, oscSupport ? false
}:

buildLua rec {
  pname = "mpv-quality-menu";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "christoph-heinrich";
    repo = "mpv-quality-menu";
    rev = "v${version}";
    hash = "sha256-yrcTxqpLnOI1Tq3khhflO3wzhyeTPuvKifyH5/P57Ns=";
  };
  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  extraScripts = lib.optional oscSupport "quality-menu-osc.lua";

  meta = with lib; {
    description = "A userscript for MPV that allows you to change youtube video quality (ytdl-format) on the fly";
    homepage = "https://github.com/christoph-heinrich/mpv-quality-menu";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lunik1 ];
  };
}
