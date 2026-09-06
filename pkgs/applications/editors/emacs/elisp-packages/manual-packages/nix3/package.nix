{
  lib,
  unstableGitUpdater,
  melpaBuild,
  fetchFromGitHub,
  promise,
  magit-section,
  s,
}:
melpaBuild {
  pname = "nix3";
  version = "0-unstable-2025-03-15";
  src = fetchFromGitHub {
    owner = "emacs-twist";
    repo = "nix3.el";
    rev = "6e8a7c3b2683a0fdae2a968e211c3585580fbca5";
    hash = "sha256-2rg5S/ElHfXFgomnkjkoPjd37jH6c52TsBhNCFvIE+4=";
  };

  files = ''(:defaults "extra/*.el")'';

  packageRequires = [
    promise
    magit-section
    s
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/emacs-twist/nix3.el";
    description = "Emacs interface to experimental commands of Nix";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ johnhamelink ];
  };
}
