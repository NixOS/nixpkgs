{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "manga-reader";

  version = "0-unstable-2025-07-15";
  src = fetchFromGitHub {
    owner = "Dudemanguy";
    repo = "mpv-manga-reader";
    rev = "bb4ec1208feb440ce430f0963373ab2db5b7d743";
    hash = "sha256-Zz2rPnnQHz2BqCM3jEJD/FuFLKtiNGWvAZpiH7jyLmo=";
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
