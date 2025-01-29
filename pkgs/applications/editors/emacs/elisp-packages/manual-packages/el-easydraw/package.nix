{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2025-01-16";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "449c1226f7108e1cf8b4b447a65fa053b6bd782f";
    hash = "sha256-u6lc2s4fqNWNCuICu832vAbMmV5X6FB8fIkJwgdBKfg=";
  };

  propagatedUserEnvPkgs = [ gzip ];

  files = ''(:defaults "msg")'';

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    homepage = "https://github.com/misohena/el-easydraw";
    description = "Embedded drawing tool for Emacs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ brahyerr ];
  };
}
