{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule rec {
  pname = "abctl";
  version = "0.29.0";

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = "abctl";
    tag = "v${version}";
    hash = "sha256-tb0KBATOitgFN49gJVrctxPKjrFY7w6AdBa2AN+scBU=";
  };

  checkFlags =
    let
      skippedTests = [
        # network access
        "TestManifestCmd"
        "TestManifestCmd_Enterprise"
        "TestManifestCmd_Nightly"
        # docker
        "TestValues_BadYaml"
        "TestInvalidHostFlag_IpAddr"
        "TestInvalidHostFlag_IpAddrWithPort"
        "TestNewWithOptions_InitErr"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  vendorHash = "sha256-ZJbZDfVB6gxToinuUNLsjBEB+7+OgC19Cc2Q8Ej7kfo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Airbyte's CLI for managing local Airbyte installations";
    homepage = "https://airbyte.com/";
    changelog = "https://github.com/airbytehq/abctl/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xelden ];
    mainProgram = "abctl";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
