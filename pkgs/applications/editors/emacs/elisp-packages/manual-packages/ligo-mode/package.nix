{
  stdenv,
  lib,
  melpaBuild,
  fetchFromGitLab,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "ligo-mode";
  version = "1.7.0-unstable-2024-08-22";

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = "47128d41a9329356cbad40a982d8144da19a9218";
    hash = "sha256-IrxPnbWrhqe3TxELsqa2y4NdcfEJMGUcGCdNuDG+rfs=";
  };

  files = ''("tools/emacs/ligo-mode.el")'';

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Major mode for editing LIGO source code";
    homepage = "https://gitlab.com/ligolang/ligo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    broken = stdenv.isDarwin; # different src hash on darwin
  };
}
