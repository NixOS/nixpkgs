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
  version = "0.301.0";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    tag = version;
    hash = "sha256-ns6Kl0sN8GeF0Br7HrRLdVmKaGMqT3Y5REuH9UJg+Yg=";
  };

  vendorHash = "sha256-LGTT7WxBlWA4pCunvFDpsqDkUhTN96PohBKTLAffr0o=";

  commonMeta = {
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };

  decorate = buildGo126Module {
    pname = "evcc-decorate";
    inherit version src vendorHash;

    subPackages = "cmd/decorate";

    meta = commonMeta // {
      description = "EVCC decorate helper";
      homepage = "https://github.com/evcc-io/evcc/tree/master/cmd/decorate";
    };
  };
in

buildGo126Module rec {
  pname = "evcc";
  inherit version src vendorHash;

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-fblf49V+fn+9iuIwwOZ/iYMxUbjtWcm3iEs9mP9l59I=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = _: {
    nativeBuildInputs = [
      decorate
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
