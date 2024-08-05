{ lib
, fetchFromGitHub
, mkYarnPackage
, nodePackages
, openssl
, prisma-engines
, python3
, nodejs
, ...
}:
mkYarnPackage rec {
  pname = "linkwarden";
  version = "2.4.9";
  # yarnFlags = [ "--production=false" ];

  # nativeBuildInputs = [nodePackages.node-gyp]; # needed for bcrypt
  extraBuildInputs = [
    nodePackages.prisma
    prisma-engines
    openssl
  ];
  src = fetchFromGitHub {
    owner = "linkwarden";
    repo = "linkwarden";
    rev = "refs/tags/v${version}";
    hash = "sha256-oSt7po/5vbxHtq96x0Oq/c9tc/jtBxouxKLpSkI7UWo=";
  };
  pkgConfig = {
    bcrypt = {
      nativeBuildInputs = [ nodePackages.node-gyp nodePackages.node-gyp-build nodePackages.node-pre-gyp nodejs python3 ];
      postInstall = ''
        yarn --offline run install --nodedir=${nodejs}
      '';
    };
  };
  doDist = false;
  configurePhase = ''
    cp -r $node_modules node_modules
    chmod +w node_modules
    export PRISMA_MIGRATION_ENGINE_BINARY="${prisma-engines}/bin/migration-engine"
    export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
    export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
    export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
    export PRISMA_FMT_BINARY="${prisma-engines}/bin/prisma-fmt"
    prisma generate
  '';
  buildPhase = ''
    runHook preBuild
    yarn --offline run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r . $out
    runHook postInstall
  '';

  meta = {
    description = "Self-hosted collaborative bookmark manager to collect, organize, and preserve webpages and articles";
    downloadPage = "https://github.com/linkwarden/linkwarden/releases";
    homepage = "https://linkwarden.app/";
    license = lib.licenses.agpl3;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
