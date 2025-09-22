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
  version = "2.17.2";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "labs";
    repo = "bird";
    rev = "v${version}";
    hash = "sha256-4kEtSVuEwJIYIk4+OBjBLz72i60TOUKIbvdNKlrcUYM=";
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

  passthru.tests = nixosTests.bird;

  meta = with lib; {
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${version}/NEWS";
    description = "BIRD Internet Routing Daemon";
    homepage = "https://bird.network.cz";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.linux;
  };
}
