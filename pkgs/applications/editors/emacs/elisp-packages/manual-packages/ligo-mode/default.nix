{
  lib,
  melpaBuild,
  fetchFromGitLab,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "ligo-mode";
  version = "1.7.0-unstable-2024-07-27";

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = "8e31c2851fb722bba177f6e372eb69783e5c03b1";
    hash = "sha256-8qADbo+7ASLlWEkNG0lPMIPoQnHOwyQipnBzImkELwc=";
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
