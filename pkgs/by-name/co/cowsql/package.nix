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
  version = "1.15.3";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-+za3pIcV4BhoImKvJlKatCK372wL4OyPbApQvGxGGGk=";
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
    tests = {
      inherit incus;
    };

    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Embeddable, replicated and fault tolerant SQL engine";
    homepage = "https://github.com/cowsql/cowsql";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ adamcstephens ];
    platforms = platforms.unix;
  };
})
