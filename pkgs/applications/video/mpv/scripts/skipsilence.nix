{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "mpv-skipsilence";
  version = "0-unstable-2025-09-06";

  src = fetchFromGitHub {
    owner = "ferreum";
    repo = "mpv-skipsilence";
    rev = "75e1334e513682f0ece6790c614c1fcbd82257cc";
    hash = "sha256-XmrVZRJAQctIiuznw/fQzs+9+QKOyTnJI2JOEWBWnVA=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Increase playback speed during silence";
    homepage = "https://github.com/ferreum/mpv-skipsilence";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
