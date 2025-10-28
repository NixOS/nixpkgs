{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libuv,
  raft-cowsql,
  sqlite,
  incus,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cowsql";
  version = "1.15.9";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7djVcozWklI/0KhDC20df+H3YQbodUZaXBnQT4Ug8oI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libuv
    raft-cowsql.dev
    sqlite
  ];

  enableParallelBuilding = true;

  doCheck = true;

  outputs = [
    "dev"
    "out"
  ];

  passthru = {
    inherit (incus) tests;

    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/cowsql/cowsql/releases/tag/${finalAttrs.version}";
    description = "Embeddable, replicated and fault tolerant SQL engine";
    homepage = "https://github.com/cowsql/cowsql";
    license = lib.licenses.lgpl3Only;
    teams = with lib.teams; [ lxc ];
    platforms = lib.platforms.unix;
  };
})
