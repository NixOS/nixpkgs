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

stdenv.mkDerivation (finalAttrs: {
  pname = "bird";
  version = "2.18";

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "labs";
    repo = "bird";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Kta8zzM/EYC3Mz3mLptaJ+pFgs1Hi7MBsWjwkR4hwL8=";
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

  env.CPP = "${stdenv.cc.targetPrefix}cpp -E";

  configureFlags = [
    "--localstatedir=/var"
    "--runstatedir=/run/bird"
  ];

  passthru.tests = nixosTests.bird2;

  meta = {
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${finalAttrs.version}/NEWS";
    description = "BIRD Internet Routing Daemon";
    homepage = "https://bird.network.cz";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ herbetom ];
    platforms = lib.platforms.linux;
  };
})
