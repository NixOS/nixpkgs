{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "openbao-plugin-secrets-oauthapp";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugin-secrets-oauthapp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tgHdZikhl77qlb7br92LofBXBkdAKYZZ4syMUnCsKsM=";
  };

  vendorHash = "sha256-AVgAWUVXGl3evrSchNxh3x6T1I1UcNQmiQ/V+EW7jUM=";

  subPackages = [ "cmd/openbao-plugin-secrets-oauthapp" ];

  ldflags = [
    "-s"
  ];

  passthru = {
    pluginType = "secret";
    pluginName = "oauthapp";
    tests = { inherit (nixosTests) openbao; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "OpenBao secrets plugin for OAuth 2.0 supporting a variety of grant types";
    homepage = "https://github.com/openbao/openbao-plugin-secrets-oauthapp";
    changelog = "https://github.com/openbao/openbao-plugin-secrets-oauthapp/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "openbao-plugin-secrets-oauthapp";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
