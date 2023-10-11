{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  file,
  libuv,
  raft-canonical,
  sqlite,
}:
stdenv.mkDerivation rec {
  pname = "cowsql";
  version = "unstable-2023-09-21";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "cowsql";
    rev = "a1d49d0d3e40b32ba655fffe14b7669c2aa1bcec";
    hash = "sha256-+za3pIcV4BhoImKvJlKatCK372wL4OyPbApQvGxGGGk=";
  };

  nativeBuildInputs = [autoreconfHook file pkg-config];
  buildInputs = [
    libuv
    raft-canonical.dev
    sqlite
  ];

  enableParallelBuilding = true;

  # tests fail
  doCheck = false;

  outputs = ["dev" "out"];

  meta = with lib; {
    description = ''
      Expose a SQLite database over the network and replicate it across a
      cluster of peers
    '';
    homepage = "https://github.com/cowsql/cowsql";
    license = licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ imbearchild ];
    platforms = platforms.linux;
  };
}
