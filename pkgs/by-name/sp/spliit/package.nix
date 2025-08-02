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
  version = "1.16.0";

  src = fetchFromGitHub {
    owner = "qvalentin";
    repo = "spliit";
    rev = "7e2d104ac549ff31c40661f6a9c1fae81e3158c0";
    # tag = version;
    hash = "sha256-H+bHW2TtefHONBfVqnov8n4yq+aYdan/wo+4pOlR/5o=";
  };

  preBuild = ''
    prisma generate
  '';

  npmDepsHash = "sha256-MD0GsSDJiTvT6xyj3Z3D91Ybnpv38R2AtdBo93KI+Tc=";

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    prisma
  ];

  env = {
    NEXT_TELEMETRY_DISABLED = 1;

    # Mock values for build
    POSTGRES_PRISMA_URL = "postgresql://postgres:1234@db";
    POSTGRES_URL_NON_POOLING = "postgresql://postgres:1234@db";
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
