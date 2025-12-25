{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.3.0-unstable-2025-12-22";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "1caace5c9b25b659d64f96c0c44015a9514e960f";
    hash = "sha256-TS/1B5Myi8dVMTvOfyvcORGz0GWBYVAqZm9rFNLAGlI=";
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
