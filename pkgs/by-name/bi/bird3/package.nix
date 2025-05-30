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
  version = "3.0.4";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "labs";
    repo = "bird";
    rev = "v${version}";
    hash = "sha256-WNQ/y07PK8Ot9lVQK+qYzXHBtXiS8vwoyKD8i85ZPmM=";
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
    homepage = "https://bird.nic.cz/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ herbetom ];
    platforms = platforms.linux;
  };
}
