{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule rec {
  pname = "abctl";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = "abctl";
    rev = "refs/tags/v${version}";
    hash = "sha256-8zNXx0J+p1ARCxxnD3Bz95uDgPD8Cr8dL4oDlc1HPxI=";
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

  vendorHash = "sha256-pGNKrWgBjMeSUDE7hiJI0h1zytF+v7yuftKFxONsOHQ=";

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
