{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:
buildLua {
  pname = "dynamic-crop";

  version = "0-unstable-2024-09-14";
  src = fetchFromGitHub {
    owner = "Ashyni";
    repo = "mpv-scripts";
    rev = "d3f5685f5209ae548f8398b21d4dcbbea766d076";
    hash = "sha256-9v8ZsBj9F5Odhfo/iWGA3Ak/+gFrbe0FldrTyCKF6tk=";
  };
  passthru.scriptName = "dynamic-crop.lua";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = ''Script to "cropping" dynamically, hard-coded black bars detected with lavfi-cropdetect filter for Ultra Wide Screen or any screen (Smartphone/Tablet)'';
    homepage = "https://github.com/Ashyni/mpv-scripts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.iynaix ];
  };
}
