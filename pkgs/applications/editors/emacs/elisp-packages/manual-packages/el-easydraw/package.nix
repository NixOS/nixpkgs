{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2025-01-06";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "9a5b5e2b071be99350bfc8db6fbc2c9c667f3725";
    hash = "sha256-lQYSUQFAv6rqvZySsFbe8B7ZqEaa2L+L3HXB231D4OQ=";
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
