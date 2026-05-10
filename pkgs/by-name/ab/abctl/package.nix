{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "abctl";
  version = "0.30.4";

  src = fetchFromGitHub {
    owner = "airbytehq";
    repo = "abctl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pnzXE3yv/0m0vsiC8iNiPBBrGnzSxbzMBwzFv0Y+O94=";
  };

  checkFlags =
    let
      skippedTests = [
        # network access
        "TestResolveChartReference"
        # docker
        "TestValues_BadYaml"
        "TestInvalidHostFlag_IpAddr"
        "TestInvalidHostFlag_IpAddrWithPort"
        "TestNewWithOptions_InitErr"
      ];
    in
    [ "-skip=^${lib.concatStringsSep "$|^" skippedTests}$" ];

  vendorHash = "sha256-hxiR1zv5TlDPuNv2X4VY3p/uTuETQkV+ifc4w09XC2I=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Airbyte's CLI for managing local Airbyte installations";
    homepage = "https://airbyte.com/";
    changelog = "https://github.com/airbytehq/abctl/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xelden ];
    mainProgram = "abctl";
    broken = stdenv.hostPlatform.isDarwin;
  };
})
