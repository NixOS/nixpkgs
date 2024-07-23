{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "isearch-prop";
  version = "0-unstable-2019-05-01";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-prop";
    rev = "4a2765f835dd115d472142da05215c4c748809f4";
    hash = "sha256-A1Kt4nm7iRV9J5yaLupwiNL5g7ddZvQs79dggmqZ7Rk=";
  };

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://www.emacswiki.org/emacs/IsearchPlus";
    description = "Search text- or overlay-property contexts";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk AndersonTorres ];
  };
}
