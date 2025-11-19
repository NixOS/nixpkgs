{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildLua {
  pname = "visualizer";
  version = "0-unstable-2025-11-07";

  src = fetchFromGitHub {
    owner = "mfcc64";
    repo = "mpv-scripts";
    rev = "fd73f95c6b642366adf1df8dd4ff998d89d2e13e";
    sha256 = "+4QV1f+8YffevXNYETHDl4Rwb5cDx+YBbaDk7MscHEU=";
  };
  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Various audio visualization";
    homepage = "https://github.com/mfcc64/mpv-scripts";
    maintainers = with maintainers; [ kmein ];
  };
}
