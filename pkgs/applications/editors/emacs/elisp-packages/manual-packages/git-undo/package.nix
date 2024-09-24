{
  lib,
  fetchFromGitHub,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "git-undo";
  version = "0-unstable-2022-08-07";

  src = fetchFromGitHub {
    owner = "jwiegley";
    repo = "git-undo-el";
    rev = "3d9c95fc40a362eae4b88e20ee21212d234a9ee6";
    hash = "sha256-xwVCAdxnIRHrFNWvtlM3u6CShsUiGgl1CiBTsp2x7IM=";
  };

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/jwiegley/git-undo-el";
    description = "Revert region to most recent Git-historical version";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ leungbk ];
  };
}
