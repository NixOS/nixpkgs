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
  # SQL extension version is 1.8, official version is beta16
  version = "1.8-beta16";

  src = fetchFromGitHub {
    owner = "orioledb";
    repo = "orioledb";
    tag = "beta16";
    hash = "sha256-HCfNzMPt80nGeVwlstUCeMpdNZYd9KhLLHYyD/Hvuhk=";
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
