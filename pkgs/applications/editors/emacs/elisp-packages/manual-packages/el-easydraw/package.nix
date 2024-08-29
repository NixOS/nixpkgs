{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2024-07-24";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "6f93e744d5f62de2176d3d0f0aa1f9e8d84ccefd";
    hash = "sha256-dXu4hDC4qE7W+KkWb9HIqYwesOKisMiZSTAulDpjyfA=";
  };

  propagatedUserEnvPkgs = [ gzip ];

  files = ''(:defaults "msg")'';

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    homepage = "https://github.com/misohena/el-easydraw";
    description = "Embedded drawing tool for Emacs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ brahyerr ];
  };
}
