{
  lib,
  melpaBuild,
  fetchFromGitHub,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "isearch-plus";
  ename = "isearch+";
  version = "3434-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-plus";
    rev = "48f8d57a51448dd3b81c93b5f55f5eaaeee1c3f7";
    hash = "sha256-jbzar5Sj7WtHOjoSe+inU6+8q7LyvYJS2DqTfzD70AQ=";
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
