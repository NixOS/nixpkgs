{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libuv
, lz4
, pkg-config
, incus
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "raft-cowsql";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "cowsql";
    repo = "raft";
    rev = "refs/tags/v${version}";
    hash = "sha256-GF+dfkdBNamaix+teJQfhiVMGFwHoAj6GeQj9EpuhYE=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ libuv lz4 ];

  enableParallelBuilding = true;

  patches = [
    # network tests either hang indefinitely, or fail outright
    ./disable-net-tests.patch

    # missing dir check is flaky
    ./disable-missing-dir-test.patch
  ];

  preConfigure = ''
    substituteInPlace configure --replace /usr/bin/ " "
  '';

  doCheck = true;

  outputs = [ "dev" "out" ];

  passthru = {
    inherit (incus) tests;

    updateScript = gitUpdater {
      rev-prefix = "v";
    };
  };

  meta = with lib; {
    description = "Asynchronous C implementation of the Raft consensus protocol";
    homepage = "https://github.com/cowsql/raft";
    license = licenses.lgpl3Only;
    platforms = platforms.linux;
    maintainers = teams.lxc.members;
  };
}
