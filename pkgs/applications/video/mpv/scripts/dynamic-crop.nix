{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  buildLua,
}:
buildLua {
  pname = "dynamic-crop";

  version = "0-unstable-2024-06-22";
  src = fetchFromGitHub {
    owner = "Ashyni";
    repo = "mpv-scripts";
    rev = "1fadd5ea3e31818db33c9372c40161db6fc1bdd3";
    hash = "sha256-nC0Iw+9PSGxc3OdYhEmFVa49Sw+rIbuFhgZvAphP4cM=";
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
