{
  lib,
  buildLua,
  fetchFromGitHub,
  gitUpdater,
  oscSupport ? false,
}:

buildLua rec {
  pname = "mpv-quality-menu";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "christoph-heinrich";
    repo = "mpv-quality-menu";
    rev = "v${version}";
    hash = "sha256-uaU4W72P7zhHzxmfr59icCAl1mJ3ycLGzkGcYasHllI=";
  };
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  extraScripts = lib.optional oscSupport "quality-menu-osc.lua";

  meta = with lib; {
    description = "Userscript for MPV that allows you to change youtube video quality (ytdl-format) on the fly";
    homepage = "https://github.com/christoph-heinrich/mpv-quality-menu";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ lunik1 ];
  };
}
