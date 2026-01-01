{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule rec {
  pname = "abctl";
<<<<<<< HEAD
  version = "0.30.3";
=======
  version = "0.29.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = "abctl";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-pQvLFfj7/uZQUqtWAsTcw2RQ3KHFuoQCBP3lBvb2LTs=";
=======
    hash = "sha256-tb0KBATOitgFN49gJVrctxPKjrFY7w6AdBa2AN+scBU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  checkFlags =
    let
      skippedTests = [
        # network access
<<<<<<< HEAD
        "TestResolveChartReference"
=======
        "TestManifestCmd"
        "TestManifestCmd_Enterprise"
        "TestManifestCmd_Nightly"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
