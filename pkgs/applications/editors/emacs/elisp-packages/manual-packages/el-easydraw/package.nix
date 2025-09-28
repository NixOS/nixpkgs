{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2025-02-21";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "f6b0f43138693b73cb65327d28bd2a4ee1b6caa7";
    hash = "sha256-IU+DMw8q1Si3CJ4FhJVkaRsjkh1Oc3psmbzdUgh0YMI=";
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
