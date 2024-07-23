{
  lib,
  melpaBuild,
  fetchFromGitHub,
  gzip,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "edraw";
  version = "1.2.0-unstable-2024-07-01";

  src = fetchFromGitHub {
    owner = "misohena";
    repo = "el-easydraw";
    rev = "a6c849619abcdd80dc82ec5417195414ad438fa3";
    hash = "sha256-CbcI1mmghc3HObg80bjScVDcJ1DHx9aX1WP2HlhAshs=";
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
