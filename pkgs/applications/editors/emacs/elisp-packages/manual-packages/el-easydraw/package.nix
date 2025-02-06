{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2025-02-01";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "7f41e93554e4855ae44c0d719f7253f873ed4cb8";
    hash = "sha256-dwmyBm+PtrfW74WRlhdXql8yLuB2fKwdvobaChKoBP0=";
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
