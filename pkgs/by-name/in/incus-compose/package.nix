{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "incus-compose";
  version = "1.1.0";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus-compose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MrVqFs7+0aeOe+SizykVAMkNlrGM/SKWY+GUWHG9xQU=";
  };

  vendorHash = "sha256-KnQQX66X41cMv3+gu+IsPE5St47SGr6i2Y/gUFpIjmQ=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/lxc/incus-compose/cmd/incus-compose/version.Version=${finalAttrs.version}"
    "-X=github.com/lxc/incus-compose/cmd/incus-compose/DefaultHealthdImage=ghcr.io/lxc/incus-compose/ic-healthd:${finalAttrs.version}"
  ];

  # tests need an incus daemon running
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Bring the familiar Docker Compose workflow to Incus — run compose.yaml files natively on Incus";
    homepage = "https://github.com/lxc/incus-compose";
    changelog = "https://github.com/lxc/incus-compose/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    teams = [ lib.teams.lxc ];
    platforms = lib.platforms.linux;
    mainProgram = "incus-compose";
  };
})
