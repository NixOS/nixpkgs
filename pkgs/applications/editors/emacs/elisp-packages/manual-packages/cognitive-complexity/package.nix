{
  lib,
  unstableGitUpdater,
  melpaBuild,
  fetchFromGitHub,
}:
melpaBuild {
  pname = "cognitive-complexity";
  version = "0-unstable-2026-04-14";
  src = fetchFromGitHub {
    owner = "emacs-vs";
    repo = "cognitive-complexity";
    rev = "b45afe9bf65943f985b645cea514212dc734349b";
    hash = "sha256-wPS/2yIQjqFWqlyf1qpd+FrvVH5KBL+kpSCW3bgmDL8=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/emacs-vs/cognitive-complexity";
    description = "Show cognitive complexity of code";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };
}
