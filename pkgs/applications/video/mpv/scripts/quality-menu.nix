{
  lib,
  buildLua,
  fetchFromGitHub,
  gitUpdater,
  oscSupport ? false,
}:

buildLua rec {
  pname = "mpv-quality-menu";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "christoph-heinrich";
    repo = "mpv-quality-menu";
    rev = "v${version}";
    hash = "sha256-W+6OYjh0S7nYrNC/P9sF7t6p1Rt/awOtO865cr6qtR0=";
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
