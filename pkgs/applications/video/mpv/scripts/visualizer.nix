{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildLua {
  pname = "visualizer";
  version = "0-unstable-2024-03-10";

  src = fetchFromGitHub {
    owner = "mfcc64";
    repo = "mpv-scripts";
    rev = "b4246984ba6dc6820adef5c8bbf793af85c9ab8e";
    sha256 = "ZNUzw4OW7z+yGTxim7CCWJdWmihDFOQAQk3bC5Ijcbs=";
  };
  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "various audio visualization";
    homepage = "https://github.com/mfcc64/mpv-scripts";
    maintainers = with maintainers; [ kmein ];
  };
}
