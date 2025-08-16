{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "mpv-skipsilence";
  version = "0-unstable-2025-08-03";

  src = fetchFromGitHub {
    owner = "ferreum";
    repo = "mpv-skipsilence";
    rev = "42e511c52c68c1aa9678e18caea41e43eee9149b";
    hash = "sha256-+sOMWFFumJUk5gFE1iCTvWub3PWzYOkulXJLCGS4fYA=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Increase playback speed during silence";
    homepage = "https://github.com/ferreum/mpv-skipsilence";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
