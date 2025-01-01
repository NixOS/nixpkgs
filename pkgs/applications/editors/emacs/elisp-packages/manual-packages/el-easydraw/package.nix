{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2024-10-04";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "ad740d87e768052b0ef5b5e7f0822c7ac1b238fb";
    hash = "sha256-xdyDikE8fUQ12Ra5j5lQUHVLKpTYtvfn1DosusQt61Q=";
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
