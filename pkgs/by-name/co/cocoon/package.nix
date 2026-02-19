{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  stdenvNoCC,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "cocoon";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "haileyok";
    repo = "cocoon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2+K4KiF0N+Y+J5dS4xQZuYlxr6OYzNloVXjxyGnEHh4=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-bux3OfHT8f1FVpBAZUP23vo8M6h8nPTJbi/GTUzhdc4=";

  passthru = {
    tests = lib.optionalAttrs stdenvNoCC.hostPlatform.isLinux { inherit (nixosTests) cocoon; };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "ATProtocol Personal Data Server written in Go with a SQLite block and blob store";
    changelog = "https://github.com/haileyok/cocoon/releases/v${finalAttrs.version}";
    homepage = "https://github.com/haileyok/cocoon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "cocoon";
  };
})
