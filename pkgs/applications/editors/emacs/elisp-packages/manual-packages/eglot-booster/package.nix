{
  lib,
  melpaBuild,
  fetchFromGitHub,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "eglot-booster";
  version = "0-unstable-2025-07-16";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "eglot-booster";
    rev = "cab7803c4f0adc7fff9da6680f90110674bb7a22";
    hash = "sha256-xUBQrQpw+JZxcqT1fy/8C2tjKwa7sLFHXamBm45Fa4Y=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/jdtsmith/eglot-booster";
    description = "Boost eglot using lsp-booster";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mannerbund ];
  };
}
