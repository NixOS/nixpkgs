{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "isearch-prop";
  version = "0-unstable-2022-12-30";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-prop";
    rev = "5787fd57977c0d6c416ce71471c3b9da246dfb78";
    hash = "sha256-Xli7TxBenl5cDMJv3Qz7ZELFpvJKStMploLpf9a+uoA=";
  };

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://www.emacswiki.org/emacs/IsearchPlus";
    description = "Search text- or overlay-property contexts";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk AndersonTorres ];
  };
}
