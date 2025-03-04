{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2025-02-15";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "7d557a3ea1b1308d3fc56607bd00fee1be36007f";
    hash = "sha256-7quQwBR5dnSkT8HZd/Tng5qQiqL+H6BCuQCWSe0B4Hw=";
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
