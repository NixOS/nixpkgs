{
  fetchFromGitHub,
  buildLua,
  lib,
  unstableGitUpdater,
}:

buildLua {
  pname = "memo";
  version = "0-unstable-2024-07-02";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "memo";
    rev = "43ad5bc37d4ac63a00dd2a8f15b9028789467da7";
    hash = "sha256-nHJ1x5R4Rw2YjB3Li3ZFbI3ZdLSqddJFzJlni4NjpH0=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Recent files menu for mpv";
    homepage = "https://github.com/po5/memo";
    license = licenses.gpl3Only;
    maintainers = with lib.maintainers; [ purrpurrn ];
  };
}
