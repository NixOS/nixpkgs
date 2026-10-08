{
  lib,
  stdenv,
  buildGo127Module,
  fetchFromGitHub,
  fetchNpmDeps,
  cacert,
  git,
  go_1_27,
  gokrazy,
  enumer,
  mockgen,
  nodejs,
  npmHooks,
  nix-update-script,
  nixosTests,
}:

let
  version = "0.315.0";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    tag = version;
    hash = "sha256-lnFsLTEz5tC07fyx95zYnvBfx3FGKKlGLbi0RsTpDBY=";
  };

  vendorHash = "sha256-JUJFOQQpbPkb4aI2SjRaTbZzTxWpV1wbWJH7EgGqmHY=";

  commonMeta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
in

buildGo127Module rec {
  pname = "evcc";
  inherit version src vendorHash;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-iSYPUjggHm1KdDAMZuJIVDQx+Sw7gRCmTtoiUp7yRUM=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = _: {
    nativeBuildInputs = [
      enumer
      go_1_27
      gokrazy
      git
      cacert
      mockgen
    ];

    preBuild = ''
      GOFLAGS="-mod=mod" make assets
    '';
  };

  tags = [
    "release"
  ];

  ldflags = [
    "-X github.com/evcc-io/evcc/util.Version=${version}"
    "-s"
    "-w"
  ];

  preBuild = ''
    export PATH="$PWD/node_modules/.bin:$PATH"
    export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
    make ui
  '';

  doCheck = !stdenv.hostPlatform.isDarwin; # darwin sandbox limitations around network access, access to /etc/protocols and likely more

  checkFlags =
    let
      skippedTests = [
        # network access
        "TestOcpp"
        "TestOctopusConfigParse"
        "TestSessionHandlerTimezoneFilter"
        "TestTemplates"
        # network access: mdns fails to start Avahi provider
        "TestControlBoxGridGuardHeartbeat"
        "TestEEBus"
        "TestShipPairing"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    tests = {
      inherit (nixosTests) evcc;
    };
    updateScript = nix-update-script { };
  };

  meta = commonMeta // {
    description = "EV Charge Controller";
    homepage = "https://evcc.io";
    changelog = "https://github.com/evcc-io/evcc/releases/tag/${version}";
    mainProgram = "evcc";
  };
}
