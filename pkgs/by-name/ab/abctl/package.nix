{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule rec {
  pname = "abctl";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = "abctl";
    tag = "v${version}";
    hash = "sha256-ZM0ae4Oiz/q4KSkxVxEXPe6oJa5fsNWzw+fX5hobc1c=";
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

  vendorHash = "sha256-9djIgVLPQmqEzDqUBipmXA8DlwYx9D4QlMna26vyJKI=";

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
