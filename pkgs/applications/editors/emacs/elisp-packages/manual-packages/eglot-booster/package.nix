{
  lib,
  melpaBuild,
  fetchFromGitHub,
  unstableGitUpdater,
  json-rpc-server,
  eglot,
  seq,
}:

melpaBuild {
  pname = "eglot-booster";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "jdtsmith";
    repo = "eglot-booster";
    rev = "e6daa6bcaf4aceee29c8a5a949b43eb1b89900ed";
    hash = "sha256-PLfaXELkdX5NZcSmR1s/kgmU16ODF8bn56nfTh9g6bs=";
  };

  packageRequires = [
    json-rpc-server
    eglot
    seq
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/jdtsmith/eglot-booster";
    description = "Boost eglot using lsp-booster";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mannerbund ];
  };
}
