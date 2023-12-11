{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libuv
, raft-cowsql
, sqlite
, incus
, gitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cowsql";
  version = "1.15.4";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-JbLiwWXOrEhqCdM8tWwxl68O5Sga4T7NYCXzqP9+Dh0=";
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

  outputs = [ "dev" "out" ];

  passthru = {
    inherit (incus) tests;

    updateScript = gitUpdater {
      rev-prefix = "v";
    };
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
