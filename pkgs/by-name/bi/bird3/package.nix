{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  flex,
  bison,
  readline,
  libssh,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "bird";
  version = "3.1.2";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "labs";
    repo = "bird";
    rev = "v${version}";
    hash = "sha256-3Ms9yozF/Ox/kSP9rzKvkrA0VBPQb1VjtbEInl8/KZM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    flex
    bison
  ];
  buildInputs = [
    readline
    libssh
  ];

  patches = [
    ./dont-create-sysconfdir-2.patch
  ];

  CPP = "${stdenv.cc.targetPrefix}cpp -E";

  configureFlags = [
    "--localstatedir=/var"
    "--runstatedir=/run/bird"
  ];

  passthru.tests = nixosTests.bird3;

  meta = {
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${version}/NEWS";
    description = "BIRD Internet Routing Daemon";
    homepage = "https://bird.nic.cz/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ herbetom ];
    platforms = lib.platforms.linux;
  };
}
