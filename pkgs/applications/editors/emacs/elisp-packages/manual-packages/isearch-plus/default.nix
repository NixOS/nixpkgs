{
  lib,
  melpaBuild,
  fetchFromGitHub,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "isearch-plus";
  ename = "isearch+";
  version = "3434-unstable-2023-09-27";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-plus";
    rev = "b10a36fb6bb8b45ff9d924107384e3bf0cee201d";
    hash = "sha256-h/jkIWjkLFbtBp9F+lhA3CulYy2XaeloLmexR0CDm3E=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://www.emacswiki.org/emacs/IsearchPlus";
    description = "Extensions to isearch";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      leungbk
      AndersonTorres
    ];
  };
}
