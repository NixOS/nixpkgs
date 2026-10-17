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
  version = "0.13";

  src = fetchFromGitHub {
    owner = "haileyok";
    repo = "cocoon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-obDLev5SlM5bV+277ymxXlpP9knf8j4I6FEPGHr2WyE=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  vendorHash = "sha256-Dxbilj8A67jjOWqqkv4B1iekQ2oUg+5oVjP1ta4YOk0=";

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
