{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  cyclonedds,
  libmysqlclient,
  mariadb,
  mbedtls,
  sqlite,
  zeromq,
  flex,
  bison,

  # for tests
  python3,
  mosquitto,
  netcat-gnu,
}:

let

  # exposing as full package in its own right would be a
  # bit absurd - repo doesn't even have a license.
  idl-serial = stdenv.mkDerivation {
    pname = "idl-serial";
    version = "unstable-2023-09-28";

    src = fetchFromGitHub {
      owner = "nanomq";
      repo = "idl-serial";
      rev = "cf63cb2c4fbe2ecfba569979b89e20e1190b5ed4";
      hash = "sha256-HM5TSMfEr4uv5BuNCQjyZganSQ/ZqT3xZQp0KLmjIEc=";
    };

    nativeBuildInputs = [
      cmake
      ninja
      flex
      bison
    ];

    # https://github.com/nanomq/idl-serial/issues/36
    hardeningDisable = [ "fortify3" ];
  };

in
stdenv.mkDerivation (finalAttrs: {
  pname = "nanomq";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "emqx";
    repo = "nanomq";
    rev = finalAttrs.version;
    hash = "sha256-aB1gEzo2dX8NY+e0Dq4ELgkUpL/NtvvuY/l539BPIng=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "DESTINATION /etc" "DESTINATION $out/etc"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    idl-serial
  ];

  buildInputs = [
    cyclonedds
    libmysqlclient
    mariadb
    mbedtls
    sqlite
    zeromq
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_BENCH" true)
    (lib.cmakeBool "BUILD_DDS_PROXY" true)
    (lib.cmakeBool "BUILD_NANOMQ_CLI" true)
    (lib.cmakeBool "BUILD_ZMQ_GATEWAY" true)
    (lib.cmakeBool "ENABLE_RULE_ENGINE" true)
    (lib.cmakeBool "NNG_ENABLE_SQLITE" true)
    (lib.cmakeBool "NNG_ENABLE_TLS" true)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=int-conversion";

  # disabled by default - not 100% reliable and making nanomq depend on
  # mosquitto would annoy people
  doInstallCheck = false;
  nativeInstallCheckInputs = [
    mosquitto
    netcat-gnu
    (python3.withPackages (
      ps: with ps; [
        jinja2
        requests
        paho-mqtt
      ]
    ))
  ];
  installCheckPhase = ''
    runHook preInstallCheck

    (
      cd ..

      # effectively distable this test because it is slow
      echo > .github/scripts/fuzzy_test.txt

      # even with the correct paho-mqtt version these tests fail, suggesting
      # websocket support is indeed broken
      substituteInPlace .github/scripts/test.py \
        --replace 'ws_test()' '#ws_test()' \
        --replace 'ws_v5_test()' '#ws_v5_test()'

      PATH="$PATH:$out/bin" python .github/scripts/test.py
    )

    runHook postInstallCheck
  '';

  passthru.tests = {
    withInstallChecks = finalAttrs.finalPackage.overrideAttrs (_: {
      doInstallCheck = true;
    });
  };

  meta = with lib; {
    description = "Ultra-lightweight and blazing-fast MQTT broker for IoT edge";
    homepage = "https://nanomq.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
})
