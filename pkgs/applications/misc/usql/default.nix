{ lib
, fetchFromGitHub
, buildGoModule
, unixODBC
, icu
}:

buildGoModule rec {
  pname = "usql";
  version = "0.12.13";

  src = fetchFromGitHub {
    owner = "xo";
    repo = "usql";
    rev = "v${version}";
    hash = "sha256-F/eOD7/w8HjJBeiXagaf4yBLZcZVuy93rfVFeSESlZo=";
  };

  vendorHash = "sha256-7rMCqTfUs89AX0VP689BmKsuvLJWU5ANJVki+JMVf7g=";

  buildInputs = [ unixODBC icu ];

  # Exclude broken impala driver
  # The driver breaks too often and is not used.
  #
  # See https://github.com/xo/usql/pull/347
  #
  excludedPackages = [
    "impala"
  ];

  # These tags and flags are copied from build-release.sh
  tags = [
    "most"
    "sqlite_app_armor"
    "sqlite_fts5"
    "sqlite_introspect"
    "sqlite_json1"
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

  meta = with lib; {
    description = "Universal command-line interface for SQL databases";
    homepage = "https://github.com/xo/usql";
    license = licenses.mit;
    maintainers = with maintainers; [ georgyo anthonyroussel ];
    platforms = with platforms; linux ++ darwin;
  };
}
