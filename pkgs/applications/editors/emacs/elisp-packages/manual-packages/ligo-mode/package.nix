{
  stdenv,
  lib,
  melpaBuild,
  fetchFromGitLab,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "ligo-mode";
  version = "1.7.0-unstable-2024-08-14";

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = "547da30202972fd9b5114ce82c4b94ddf6c8e8f7";
    hash = "sha256-kGFV3Ci8F+vK1LCQCsdpxeoLHarfa4dItQkJDihE7eI=";
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
