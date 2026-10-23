{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  nixosTests,
}:

buildGoModule (finalAttrs: {
  pname = "vault-plugin-secrets-gitlab";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "ilijamt";
    repo = "vault-plugin-secrets-gitlab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5amQWZn84Ol108hJIhVMA4pNwIsaoS+zSLl4KcsIVDo=";
  };

  vendorHash = "sha256-r8lT0hW/S1/QBHM3Lt7ZqUNrc/MGaO3OZOqbPMXlWf4=";

  subPackages = [ "cmd/vault-plugin-secrets-gitlab" ];

  ldflags = [
    "-s"
    "-X github.com/ilijamt/vault-plugin-secrets-gitlab.Version=v${finalAttrs.version}"
  ];

  passthru = {
    pluginType = "secret";
    pluginName = "gitlab";
    tests = { inherit (nixosTests) openbao; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "OpenBao secrets plugin for GitLab access tokens";
    homepage = "https://github.com/ilijamt/vault-plugin-secrets-gitlab";
    changelog = "https://github.com/ilijamt/vault-plugin-secrets-gitlab/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "vault-plugin-secrets-gitlab";
    maintainers = with lib.maintainers; [ kranzes ];
  };
})
