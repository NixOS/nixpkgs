{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:

buildLua {
  pname = "mpv-skipsilence";
  version = "0-unstable-2024-05-06";

  src = fetchFromGitHub {
    owner = "ferreum";
    repo = "mpv-skipsilence";
    rev = "5ae7c3b6f927e728c22fc13007265682d1ecf98c";
    hash = "sha256-fg8vfeb68nr0bTBIvr0FnRnoB48/kV957pn22tWcz1g=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Increase playback speed during silence";
    homepage = "https://github.com/ferreum/mpv-skipsilence";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ mksafavi ];
  };
}
