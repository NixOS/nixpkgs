{
  fetchFromGitHub,
  buildLua,
  lib,
  unstableGitUpdater,
}:

buildLua {
  pname = "evafast";
  version = "0-unstable-2024-02-09";

  src = fetchFromGitHub {
    owner = "po5";
    repo = "evafast";
    rev = "92af3e2e1c756ce83f9d0129c780caeef1131a0b";
    hash = "sha256-BGWD2XwVu8zOSiDJ+9oWi8aPN2Wkw0Y0gF58X4f+tdI=";
  };

  # Drop the `branch` parameter once upstream merges `rewrite` back into `master`
  passthru.updateScript = unstableGitUpdater { branch = "rewrite"; };

  meta = with lib; {
    description = "Seeking and hybrid fastforwarding like VHS";
    homepage = "https://github.com/po5/evafast";
    license = licenses.unfree; # no license; see https://github.com/po5/evafast/issues/15
    maintainers = with lib.maintainers; [ purrpurrn ];
  };
}
