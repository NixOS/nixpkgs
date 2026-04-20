{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule (finalAttrs: {
  pname = "goose";
  version = "3.27.0";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = "goose";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wpnheZJ2+xnk8N/hE5Cyf38/yODQC5+SlDml9vH0oRw=";
  };

  proxyVendor = true;
  vendorHash = "sha256-0G6kE5ScpsIG2hLzZ9hnyig4LuN6rTdwirR+ldC2+ps=";

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
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "goose";
  };
})
