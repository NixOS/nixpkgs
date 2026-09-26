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
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "haileyok";
    repo = "cocoon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Qpv8cZmAkhIZFM4fCT4oXBYHlXzqFDRMRErjjZG67A=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-BFnZlUT4/jVdTC7bccKXLa9KiHaUM11J76DcFuBI7Ts=";

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
