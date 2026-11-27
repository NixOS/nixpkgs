{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "goose";
  version = "3.30.2";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = "goose";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6DK92Dcm7EBlSxkUXRTyFELW8boh/hfCGY48r46bYS4=";
  };

  proxyVendor = true;
  vendorHash = "sha256-P++7aP2OB2tVc/wm3eipfk+R3lmk5byBi8cU6/ngbX8=";

  # skipping: end-to-end tests require a docker daemon
  postPatch = ''
    rm -r tests/gomigrations
  '';

  subPackages = [
    "cmd/goose"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
  ];

  checkFlags = [
    # NOTE:
    # - skipping: these also require a docker daemon
    # - these are for go tests that live outside of the /tests directory
    "-skip=TestClickUpDown|TestClickHouseFirstThree|TestLockModeAdvisorySession|TestDialectStore|TestGoMigrationStats|TestPostgresSessionLocker"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/pressly/goose/releases/tag/v${finalAttrs.version}";
    description = "Database migration tool which supports SQL migrations and Go functions";
    homepage = "https://pressly.github.io/goose/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kamadorueda ];
    mainProgram = "goose";
  };
})
