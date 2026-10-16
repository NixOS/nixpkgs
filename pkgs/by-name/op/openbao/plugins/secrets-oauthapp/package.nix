{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "openbao-plugin-secrets-oauthapp";
  version = "3.4.1";

  src = fetchFromGitHub {
    owner = "openbao";
    repo = "openbao-plugin-secrets-oauthapp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/ww6SpHxPWiChbiU1J7b8pd3pxSCUplj7ncju6Dg1ow=";
  };

  vendorHash = "sha256-NpB/ZlXDZ9TRKIK5m5o2QMrjduvR9n2CFc3DKndcNoU=";

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
