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
  version = "1.15.6";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-cr6AT/n2/6DuGK53JvGLwCkMi4+fS128qxj3X9SJYuw=";
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
    changelog = "https://github.com/cowsql/cowsql/releases/tag/${version}";
    description = "Embeddable, replicated and fault tolerant SQL engine";
    homepage = "https://github.com/cowsql/cowsql";
    license = licenses.lgpl3Only;
    maintainers = teams.lxc.members;
    platforms = platforms.unix;
  };
})
