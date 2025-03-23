{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "manga-reader";

  version = "0-unstable-2025-02-16";
  src = fetchFromGitHub {
    owner = "Dudemanguy";
    repo = "mpv-manga-reader";
    rev = "68824666b669ec101835f6d7aa510896e82ec30f";
    hash = "sha256-9PGJ2OrAcbJIBLI/XGT2HQpC3KuoYnn1ws9oB9AnHQA=";
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
