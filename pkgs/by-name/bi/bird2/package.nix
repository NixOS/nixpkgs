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

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "bird";
  version = "2.17.3";
=======
stdenv.mkDerivation rec {
  pname = "bird";
  version = "2.17.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    domain = "gitlab.nic.cz";
    owner = "labs";
    repo = "bird";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uwvb5u12Hwsv0uouEpGQiTgMgprWUpghbwD3TmKBoOM=";
=======
    rev = "v${version}";
    hash = "sha256-4kEtSVuEwJIYIk4+OBjBLz72i60TOUKIbvdNKlrcUYM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

  passthru.tests = nixosTests.bird2;

  meta = {
<<<<<<< HEAD
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${finalAttrs.version}/NEWS";
=======
    changelog = "https://gitlab.nic.cz/labs/bird/-/blob/v${version}/NEWS";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "BIRD Internet Routing Daemon";
    homepage = "https://bird.network.cz";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ herbetom ];
    platforms = lib.platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
