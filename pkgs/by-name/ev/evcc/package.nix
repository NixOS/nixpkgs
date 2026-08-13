{
  lib,
  stdenv,
  buildGo126Module,
  fetchFromGitHub,
  fetchNpmDeps,
  cacert,
  git,
  go_1_26,
  gokrazy,
  enumer,
  mockgen,
  nodejs,
  npmHooks,
  nix-update-script,
  nixosTests,
}:

let
  version = "0.313.3";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    tag = version;
    hash = "sha256-mf8Jf+JtbcTQ227Dp0oRKBRpNKg2Gv+jkPsi36+Uogw=";
  };

  vendorHash = "sha256-QJsdBqa/JHaBig4bRtU3LqlYwh/BHnP3vg8YM3reuDY=";

  commonMeta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
in

buildGo126Module rec {
  pname = "evcc";
  inherit version src vendorHash;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-2BBHdp3WVJReXfKpM0Hl1AT4vx1584BFbqdPMBGNYB4=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = _: {
    nativeBuildInputs = [
      enumer
      go_1_26
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
