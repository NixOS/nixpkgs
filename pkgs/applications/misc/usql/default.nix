{ lib
, fetchFromGitHub
, buildGoModule
, unixODBC
, icu
, nix-update-script
, testers
, usql
}:

buildGoModule rec {
  pname = "usql";
  version = "0.14.6";

  src = fetchFromGitHub {
    owner = "xo";
    repo = "usql";
    rev = "v${version}";
    hash = "sha256-RxnxF+KzRNPQ5w5zsk9g1tr557vGe7bi32pSiGL2rK8=";
  };

  buildInputs = [ unixODBC icu ];

  vendorHash = "sha256-66HQNh8GNPGYsA4PXIij2PMUnj/SxLSQ/+5junR22UE=";
  proxyVendor = true;

  # Exclude broken impala & hive driver
  # These drivers break too often and are not used.
  #
  # See https://github.com/xo/usql/pull/347
  #
  excludedPackages = [
    "impala"
    "hive"
  ];

  # These tags and flags are copied from build-release.sh
  tags = [
    "most"
    "sqlite_app_armor"
    "sqlite_fts5"
    "sqlite_introspect"
    "sqlite_json1"
    "sqlite_math_functions"
    "sqlite_stat4"
    "sqlite_userauth"
    "sqlite_vtable"
    "sqlite_icu"
    "no_adodb"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/xo/usql/text.CommandVersion=${version}"
  ];

  # All the checks currently require docker instances to run the databases.
  doCheck = false;

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      inherit version;
      package = usql;
      command = "usql --version";
    };
  };

  meta = with lib; {
    description = "Universal command-line interface for SQL databases";
    homepage = "https://github.com/xo/usql";
    changelog = "https://github.com/xo/usql/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ georgyo anthonyroussel ];
    platforms = with platforms; linux ++ darwin;
  };
}
