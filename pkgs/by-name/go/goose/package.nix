{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "goose";
  version = "3.24.1";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Dy6HHmf1kHd0KJ1EuPnNaa/zIQPUClvwJ8gUR7pi3Cw=";
  };

  proxyVendor = true;
  vendorHash = "sha256-wTzQoDgo54FY4Mt4rfZc075p/FGu3WhS+TSc3Bps75M=";

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
    "-X=main.version=${version}"
  ];

  checkFlags = [
    # NOTE:
    # - skipping: these also require a docker daemon
    # - these are for go tests that live outside of the /tests directory
    "-skip=TestClickUpDown|TestClickHouseFirstThree|TestLockModeAdvisorySession|TestDialectStore|TestGoMigrationStats|TestPostgresSessionLocker"
  ];

  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = with lib; {
    description = "Database migration tool which supports SQL migrations and Go functions";
    homepage = "https://pressly.github.io/goose/";
    license = licenses.bsd3;
    maintainers = [ ];
    mainProgram = "goose";
  };
}
