{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  openssl,
  prisma,
  prisma-engines,
  nixosTests,
}:

buildNpmPackage rec {
  pname = "spliit";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "spliit-app";
    repo = "spliit";
    tag = version;
    hash = "sha256-rFnaYmS0IA2Bh6+aOUVsJRYlBHzMPDTJzdCyPhBD8LA=";
  };

  preBuild = ''
    prisma generate
    # The build.env file is required for the building, during runtime it will not be used.
    cp ./scripts/build.env .env
  '';

  npmDepsHash = "sha256-0wMd6bxWsIv90eHVt95Y8//AUERx2P9LpzeO05DIm1U=";

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    prisma
  ];

  env = {
    NEXT_TELEMETRY_DISABLED = 1;
  };

  postBuild = ''
    rm -r .next/cache
  '';

  postInstall = ''
    cp -r .next $out/lib/node_modules/spliit2/
    rm -r $out/lib/node_modules/spliit2/{scripts,src}
    makeWrapper $out/lib/node_modules/spliit2/node_modules/.bin/next $out/bin/spliit \
      --chdir $out/lib/node_modules/spliit2 \
      --set PRISMA_SCHEMA_ENGINE_BINARY ${lib.getExe' prisma-engines "schema-engine"} \
      --set PRISMA_QUERY_ENGINE_BINARY ${lib.getExe' prisma-engines "query-engine"} \
      --set PRISMA_QUERY_ENGINE_LIBRARY ${lib.getLib prisma-engines}/lib/libquery_engine.node \
      --run "$out/lib/node_modules/spliit2/node_modules/.bin/prisma migrate deploy" \
      --add-flags start \
  '';

  # Skip postinstall which runs prisma commands
  npmFlags = [ "--ignore-scripts" ];
  npmPruneFlags = [
    "--ignore-scripts"
    "--omit=optional"
    "--omit=dev"
  ];

  passthru.tests = {
    spliit = nixosTests.spliit;
  };

  meta = {
    description = "Web UI for sharing expenses with your friends and family, a free and Open Source Alternative to Splitwise";
    homepage = "https://spliit.app/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qvalentin ];
    mainProgram = "spliit";
  };
}
