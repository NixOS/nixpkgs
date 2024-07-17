{
  lib,
  melpaBuild,
  fetchFromGitLab,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "ligo-mode";
  version = "1.7.1-unstable-2024-06-28";

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = "a62dff504867c4c4d9e0047114568a6e6b1eb291";
    hash = "sha256-YnI2sZCE5rStWsQYY/D+Am1rep4UdK28rlmPMmJeY50=";
  };

  files = ''("tools/emacs/ligo-mode.el")'';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Major mode for editing LIGO source code";
    homepage = "https://gitlab.com/ligolang/ligo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
