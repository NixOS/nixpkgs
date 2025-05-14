{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "manga-reader";

  version = "0-unstable-2025-04-16";
  src = fetchFromGitHub {
    owner = "Dudemanguy";
    repo = "mpv-manga-reader";
    rev = "41c4be078fe6250b87eea21545c74d649719f8e4";
    hash = "sha256-uUaKqPtONuoRuVqtP0FwcUdhG2WlPRfizuZIzDPPjac=";
  };
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Manga reading script for mpv";
    longDescription = ''
      mpv-manga-reader is a script aimed at making mpv a usable manga reader.
    '';
    homepage = "https://github.com/Dudemanguy/mpv-manga-reader";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ idlip ];
  };
}
