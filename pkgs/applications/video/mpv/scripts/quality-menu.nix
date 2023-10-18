{ lib
, buildLua
, fetchFromGitHub
, oscSupport ? false
}:

buildLua rec {
  pname = "mpv-quality-menu";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "christoph-heinrich";
    repo = "mpv-quality-menu";
    rev = "v${version}";
    hash = "sha256-93WoTeX61xzbjx/tgBgUVuwyR9MkAUzCfVSrbAC7Ddc=";
  };

  passthru.scriptName = "quality-menu.lua";
  scriptPath = if oscSupport then "*.lua" else passthru.scriptName;

  meta = with lib; {
    description = "A userscript for MPV that allows you to change youtube video quality (ytdl-format) on the fly";
    homepage = "https://github.com/christoph-heinrich/mpv-quality-menu";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lunik1 ];
  };
}
