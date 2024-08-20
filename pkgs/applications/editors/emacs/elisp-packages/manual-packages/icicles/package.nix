{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "icicles";
  version = "0-unstable-2023-07-27";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "icicles";
    rev = "dfc1d9caf1b5156567292c9548547a2975a841bc";
    hash = "sha256-Xbt0D9EgmvN1hDTeLbdxq1ARHObj8M4GfH2sbFILRTI=";
  };

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://emacswiki.org/emacs/Icicles";
    description = "Emacs library that enhances minibuffer completion";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
