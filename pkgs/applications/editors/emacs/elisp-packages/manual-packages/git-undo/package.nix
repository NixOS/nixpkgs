{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "git-undo";
  version = "0-unstable-2025-09-22";

  src = fetchFromGitHub {
    owner = "jwiegley";
    repo = "git-undo-el";
    rev = "1e94d2dad39ffa168005dee182dde5694416d9c9";
    hash = "sha256-EppewewNPWVbQN76LVoebtKu+FOFCnWDhDeUognPmAo=";
  };

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/jwiegley/git-undo-el";
    description = "Revert region to most recent Git-historical version";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
