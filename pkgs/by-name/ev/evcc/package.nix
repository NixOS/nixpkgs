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
  version = "0.317.1";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    tag = version;
    hash = "sha256-wtqqmmhb0zdwmA+aYPTEK/mMK8lQefJgJxmZEBu2Ayc=";
  };

  vendorHash = "sha256-0u3qIry84kZoj/pqL20uaVn2p+vRfmT5lYY43G0q9RI=";

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
    hash = "sha256-WmUMaLPjEmP3bMLjohsMSRk7SLBVRBGX0M1l7ALgdKY=";
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
