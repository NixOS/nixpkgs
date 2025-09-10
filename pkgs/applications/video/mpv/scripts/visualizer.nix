{
  lib,
  buildLua,
  fetchFromGitHub,
  unstableGitUpdater,
}:
buildLua {
  pname = "visualizer";
  version = "0-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "mfcc64";
    repo = "mpv-scripts";
    rev = "bf6776f5c3dae8d83ba29b820496af89dc436613";
    sha256 = "9ApUBXjH4TKPP4P/fUXSNYbJu2AH6HBYt+1K+sHB7yE=";
  };
  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Various audio visualization";
    homepage = "https://github.com/mfcc64/mpv-scripts";
    maintainers = with maintainers; [ kmein ];
  };
}
