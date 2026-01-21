{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "manga-reader";

  version = "0-unstable-2026-01-16";
  src = fetchFromGitHub {
    owner = "Dudemanguy";
    repo = "mpv-manga-reader";
    rev = "a93e03bc837d501760dd38155c8e945d66a3a3ed";
    hash = "sha256-UG1MRtwljoKi6kct8mDZSHxz9mzQ1qHnqohX7e5nj40=";
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
