{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2024-12-18";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "1c46469d0ea3642958eaf7cea1016fcf05b4daec";
    hash = "sha256-Z7LPC112FXHtDop1HXPnR6S+cSqfEW1HuYS8YD/qM+c=";
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
