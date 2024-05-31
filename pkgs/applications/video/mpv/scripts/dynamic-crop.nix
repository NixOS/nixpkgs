{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:
buildLua {
  pname = "dynamic-crop";

  version = "0-unstable-2023-12-22";
  src = fetchFromGitHub {
    owner = "Ashyni";
    repo = "mpv-scripts";
    rev = "c79a46ba03631eb2a9b4f598aab0b723f03fc531";
    hash = "sha256-W4Dj2tyJHeHLqAndrzllKs4iwMe3Tu8rfzEGBHuke6s=";
  };
  passthru.scriptName = "dynamic-crop.lua";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = ''Script to "cropping" dynamically, hard-coded black bars detected with lavfi-cropdetect filter for Ultra Wide Screen or any screen (Smartphone/Tablet).'';
    homepage = "https://github.com/Ashyni/mpv-scripts";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.iynaix ];
  };
}
