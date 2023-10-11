{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, libuv
, raft-cowsql
, sqlite
, incus
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "cowsql";
  version = "unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    rev = "b728f0a43b9ad416f9c5fa1fda8b205c7a469d80";
    hash = "sha256-B4ORrsUTfk/7glSpDndw1fCfFmd72iFr+2Xm5CryeZQ=";
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

    updateScript = unstableGitUpdater { };
  };

  meta = with lib; {
    description = "Embeddable, replicated and fault tolerant SQL engine";
    homepage = "https://github.com/cowsql/cowsql";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ adamcstephens ];
    platforms = platforms.unix;
  };
}
