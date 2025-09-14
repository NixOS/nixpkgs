{
  lib,
  buildGoModule,
  fetchFromGitHub,
  stdenv,
}:

buildGoModule rec {
  pname = "goose";
  version = "3.25.0";

  src = fetchFromGitHub {
    owner = "pressly";
    repo = "goose";
    rev = "v${version}";
    hash = "sha256-ouyvxlnJQIMqRZt4nsR01+9p227FGBlHoCMAq6Ufh7A=";
  };

  proxyVendor = true;
  vendorHash = "sha256-Cpw2xJWWW85LUS5K+KM2fCUISYwLFjsdk0gPRgIZKP4=";

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
