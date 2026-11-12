{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "goose";
  version = "3.30.0";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = "goose";
    rev = "v${finalAttrs.version}";
    hash = "sha256-pWpvqXcWo5syU4eoMoJ34s+oBX+3qafjG1bUGYI6XuM=";
  };

  proxyVendor = true;
  vendorHash = "sha256-nphSQeak6TkYLZiwIB/iJMUvtm+gJEcqUG6gteWIcTs=";

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

  meta = {
    description = "Database migration tool which supports SQL migrations and Go functions";
    homepage = "https://pressly.github.io/goose/";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "goose";
  };
})
