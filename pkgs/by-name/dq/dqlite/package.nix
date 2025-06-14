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
  lxd-lts,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dqlite";
  version = "1.18.1";

  src = fetchFromGitHub {
    owner = "canonical";
    repo = "dqlite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7ou077ozbpH21PcvEEcprr4UYJ/X398Ph9dh5C3YyBQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    file
    pkg-config
  ];
  buildInputs = [
    libuv
    raft-canonical.dev
    sqlite
  ];

  enableParallelBuilding = true;

  # tests fail
  doCheck = false;

  outputs = [
    "dev"
    "out"
  ];

  passthru.tests = {
    inherit lxd-lts;
  };

  meta = {
    description = ''
      Expose a SQLite database over the network and replicate it across a
      cluster of peers
    '';
    homepage = "https://dqlite.io/";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
