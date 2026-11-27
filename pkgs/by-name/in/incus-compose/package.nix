{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "incus-compose";
  version = "1.4.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus-compose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f+OO0g5Ol6QQBSkI8ksKHDrYkZG4311yGkqIjezGxNs=";
  };

  vendorHash = "sha256-HDVaLqOG5G3YyYpERHi5RKtmkmyI1AkqBEqshF6B3q4=";

  subPackages = [ "cmd/incus-compose" ];

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
