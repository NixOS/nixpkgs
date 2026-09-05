{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "incus-compose";
  version = "1.3.2";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lxc";
    repo = "incus-compose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2mKWKFcWxWFqJx2N8+dhhes1AxjfmGLPEQzgKW2Bo04=";
  };

  vendorHash = "sha256-ji1QGBQWDpHJ+kMS/TK7cNFyqeEcBQK9fn1F5zenIBc=";

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
