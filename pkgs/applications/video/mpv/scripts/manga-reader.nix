{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua rec {
  pname = "manga-reader";

  version = "0-unstable-2024-03-17";
  src = fetchFromGitHub {
    owner = "Dudemanguy";
    repo = "mpv-manga-reader";
    rev = "6b65d98be7d20c8e272a4caa6c5018ed3a8bb2b3";
    hash = "sha256-54n513lpn1KCErXJHqL+GKdDE1P52LolS6xDott/epY=";
  };
  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Manga reading script for mpv";
    longDescription = ''
      mpv-manga-reader is a script aimed at making mpv a usable manga reader.
    '';
    homepage = "https://github.com//mpv-manga-reader";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ idlip ];
  };
}
