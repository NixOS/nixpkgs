{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "isearch-prop";
  version = "0-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "isearch-prop";
    rev = "7b32697c16541036abadbbb4d65dd67a4f1d2812";
    hash = "sha256-NmFkbxiRFAqi1TaOFfmAOgIs1QZMKXkJfMmXL9fsV14=";
  };

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://www.emacswiki.org/emacs/IsearchPlus";
    description = "Search text- or overlay-property contexts";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ leungbk AndersonTorres ];
  };
}
