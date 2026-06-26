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
  version = "0.309.1";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    tag = version;
    hash = "sha256-fMWLr8UrwejLlPiPdcs5lLd//81iqvuE5Ia9Ne0d3l4=";
  };

  vendorHash = "sha256-lCXIgJuUg5NG8E/iYobGxtvxfTk77Y8ZzVi0GsjbbHw=";

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
    hash = "sha256-ypBg2TQ3qbc8cIBfFqICbNSCsIdokOtaFOqFD9bnMQM=";
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
    "test"
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
