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
  # SQL extension version is 1.7, official version is beta15
  version = "1.7-beta15";

  src = fetchFromGitHub {
    owner = "orioledb";
    repo = "orioledb";
    tag = "beta15";
    hash = "sha256-ndggHQb/knC1/42k8hCynQGIfEddKMj6PKnA3CcRnno=";
  };

  buildInputs = postgresql.buildInputs ++ [
    curl
  ];

  nativeBuildInputs = [
    python3
  ];

  makeFlags = [ "USE_PGXS=1" ];

  meta = {
    inherit (postgresql.meta) description maintainers;
    license = lib.licenses.OR [
      lib.licenses.asl20
      lib.licenses.postgresql
    ];
  };
})
