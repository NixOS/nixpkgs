{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildLua {
  pname = "visualizer";
  version = "0-unstable-2024-09-26";

  src = fetchFromGitHub {
    owner = "mfcc64";
    repo = "mpv-scripts";
    rev = "bff344ee2aeaa0153c7e593dc262d68bcc3031c6";
    sha256 = "kNf5b153fIbKja1ZUOV3w4taH5CWjAJhGUMywXF6dMg=";
  };
  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "various audio visualization";
    homepage = "https://github.com/mfcc64/mpv-scripts";
    maintainers = with maintainers; [ kmein ];
  };
}
