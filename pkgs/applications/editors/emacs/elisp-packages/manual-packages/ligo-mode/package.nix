{
  stdenv,
  lib,
  melpaBuild,
  fetchFromGitLab,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "ligo-mode";
  version = "1.7.0-unstable-2024-08-01";

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = "454e4a505212b8bd80ac3c75a1432320b9be2604";
    hash = "sha256-Z7bv+ulGwnczrSWWC1RIUzSI4wAF9AtObdi5bBfYsOs=";
  };

  files = ''("tools/emacs/ligo-mode.el")'';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Major mode for editing LIGO source code";
    homepage = "https://gitlab.com/ligolang/ligo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    broken = stdenv.isDarwin; # different src hash on darwin
  };
}
