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
  version = "1.15.8";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rwTa9owtnkyI9OpUKLk6V7WbAkqlYucpGzPnHHvKW/A=";
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

  meta = with lib; {
    changelog = "https://github.com/cowsql/cowsql/releases/tag/${finalAttrs.version}";
    description = "Embeddable, replicated and fault tolerant SQL engine";
    homepage = "https://github.com/cowsql/cowsql";
    license = licenses.lgpl3Only;
    maintainers = teams.lxc.members;
    platforms = platforms.unix;
  };
})
