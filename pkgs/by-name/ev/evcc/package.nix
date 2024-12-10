{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  fetchNpmDeps,
  cacert,
  git,
  go,
  enumer,
  mockgen,
  nodejs,
  npmHooks,
  nix-update-script,
  nixosTests,
}:

buildGoModule rec {
  pname = "evcc";
  version = "0.131.6";

  src = fetchFromGitHub {
    owner = "evcc-io";
    repo = "evcc";
    rev = version;
    hash = "sha256-r9GaihxC9ZQtTzKqfJ3LLDMzDEXeud7vTFEMOf0whFU=";
  };

  vendorHash = "sha256-x0EWFsR/O2Ztg39DL+yZx2ZDzJHADo2aPAeg/i+5KqM=";

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-4pQYv5UKoz3Gu5OS0zoYrjrFYD796MDb7ofWbTv3HlU=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  overrideModAttrs = _: {
    nativeBuildInputs = [
      enumer
      go
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
    "-X github.com/evcc-io/evcc/server.Commit=${src.rev}"
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
    tests = {
      inherit (nixosTests) evcc;
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "EV Charge Controller";
    homepage = "https://evcc.io";
    changelog = "https://github.com/evcc-io/evcc/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
