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
  version = "1.10.2";

  src = fetchFromGitHub {
    owner = "orioledb";
    repo = "orioledb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/0qX8vvLxdWpP7RFvThWRO4g+XEEtyaFJedAttFg06c=";
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
