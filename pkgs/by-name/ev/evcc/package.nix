{
  lib,
  stdenv,
  buildGo124Module,
  fetchFromGitHub,
  fetchNpmDeps,
  cacert,
  git,
  go_1_24,
  gokrazy,
  enumer,
  mockgen,
  nodejs,
  npmHooks,
  nix-update-script,
  nixosTests,
}:

let
  version = "0.201.1";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    tag = version;
    hash = "sha256-nsA/tJXRuL1Ql0N1OR5DeFjXI0PUtSa65hXH6C0Uxds=";
  };

  vendorHash = "sha256-NUDGqBmRL7L7/RDy68YG+nAz9Sj1Ink0tAbx9or/h1Q=";

  commonMeta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };

  decorate = buildGo124Module {
    pname = "evcc-decorate";
    inherit version src vendorHash;

    subPackages = "cmd/decorate";

    meta = commonMeta // {
      description = "EVCC decorate helper";
      homepage = "https://github.com/evcc-io/evcc/tree/master/cmd/decorate";
    };
  };
in

buildGo124Module rec {
  pname = "evcc";
  inherit version src vendorHash;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-iaQNLbbNvklSAEGAveOqStruL+LOpHdmGQqtERkagWU=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = _: {
    nativeBuildInputs = [
      decorate
      enumer
      go_1_24
      gokrazy
      git
      cacert
      mockgen
    ];

    preBuild = ''
      make assets
    '';
  };

  tags = [
    "release"
    "test"
  ];

  ldflags = [
    "-X github.com/evcc-io/evcc/server.Version=${version}"
    "-X github.com/evcc-io/evcc/server.Commit=${src.tag}"
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
        "TestOctopusConfigParse"
        "TestTemplates"
        "TestOcpp"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  passthru = {
    inherit decorate;
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
