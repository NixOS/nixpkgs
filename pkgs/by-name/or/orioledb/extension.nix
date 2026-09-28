{
  curl,
  fetchFromGitHub,
  lib,
  postgresql,
  postgresqlBuildExtension,
  postgresqlTestExtension,
  python3,
}:

postgresqlBuildExtension (finalAttrs: {
  pname = "orioledb";
  # SQL extension version is 1.10, official version is beta18
  version = "1.10-beta18";

  src = fetchFromGitHub {
    owner = "orioledb";
    repo = "orioledb";
    tag = "beta18";
    hash = "sha256-kmNfneISVhlD9Pmnl69pkiAX77MzpzyJQB/5wQ1wiZc=";
  };

  buildInputs = postgresql.buildInputs ++ [
    curl
  ];

  nativeBuildInputs = [
    python3
  ];

  makeFlags = [ "USE_PGXS=1" ];

  meta =
    # Inheriting maintainers from `postgresql` is only OK to do,
    # because it's the orioledb-specific fork of PostgreSQL.
    # Once these patches are upstreamed and the extension can
    # run on stock PG, this meta section needs to be adjusted.
    assert postgresql.pname == "orioledb-postgres";
    {
      inherit (postgresql.meta) description maintainers;
      license = lib.licenses.OR [
        lib.licenses.asl20
        lib.licenses.postgresql
      ];
    };
})
