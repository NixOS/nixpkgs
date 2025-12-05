{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "8007f50c1c1734325c47939904f486753c7dd8ee";
    hash = "sha256-YESpl+gSSC1eIOEQ8QevfTZ0Ar9wO4pzC12wVmDpDOA=";
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
