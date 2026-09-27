{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  zeromq,
  czmq,
  libsodium,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prime-server";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "kevinkreiser";
    repo = "prime_server";
    tag = finalAttrs.version;
    hash = "sha256-B6vy/y4PDEpnxXuMpAisBq5avNpW84q/+9zbuNBOnko=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ libsodium ];
  propagatedBuildInputs = [
    curl
    czmq
    zeromq
  ];

  passthru.tests.simple =
    runCommand "prime-server-test"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          curl
        ];
      }
      ''
        prime_serverd tcp://127.0.0.1:8001 1 0 &
        pid=$!
        trap 'kill $pid' EXIT

        test "$(curl -fsS --retry 30 --retry-delay 1 --retry-connrefused 'http://127.0.0.1:8001/is_prime?possible_prime=17')" = 17

        touch "$out"
      '';

  meta = {
    description = "Non-blocking (web)server API for distributed computing and SOA based on zeromq";
    homepage = "https://github.com/kevinkreiser/prime_server";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      Thra11
      karlbeecken
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
