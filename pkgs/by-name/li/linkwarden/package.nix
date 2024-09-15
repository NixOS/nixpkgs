{
  lib,
  fetchFromGitHub,
  mkYarnPackage,
  nodePackages,
  openssl,
  prisma-engines,
  python3,
  nodejs,
  runCommand,
  yarn,
  writeShellScript,
}:
mkYarnPackage rec {
  pname = "linkwarden";
  version = "2.7.1";
  # yarnFlags = [ "--production=false" ];

  extraBuildInputs = [
    nodePackages.prisma
    prisma-engines
    openssl
  ];
  src = fetchFromGitHub {
    owner = "linkwarden";
    repo = "linkwarden";
    rev = "refs/tags/v${version}";
    hash = "sha256-J93vfpvg8pYt+cw2jpt33JLNTA3LFxdvPmVEeLs177Q=";
  };
  pkgConfig = {
    bcrypt = {
      nativeBuildInputs = [
        nodePackages.node-gyp
        nodePackages.node-gyp-build
        nodePackages.node-pre-gyp
        nodejs
        python3
      ];
      postInstall = ''
        yarn --offline run install --nodedir=${nodejs}
      '';
    };
  };
  doDist = false;
  configurePhase = ''
    export HOME=$(mktemp -d)
    cat > .env << EOF
    NEXTAUTH_SECRET=NIXPKGS_NEXTAUTH_SECRET
    NEXTAUTH_URL=NIXPKGS_NEXTAUTH_URL
    DATABASE_URL=postgres://NIXPKGS_DATABASE_URL
    EOF
    cp -r $node_modules node_modules
    chmod +w -R node_modules
    export PRISMA_MIGRATION_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
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

  passthru.withUserConfiguration =
    {
      authUrl,
      secret ? null,
      secretFile ? null,
      databaseURI,
    }:
    {
      preStart =
        let
          localSecret = if secret != null then secret else "cat ${secretFile}";
        in
        runCommand "${pname}-${version}-preStart" ''
          export PRISMA_MIGRATION_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
          export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
          export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
          export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
          export PRISMA_FMT_BINARY="${prisma-engines}/bin/prisma-fmt"
          _SECRET=${localSecret}
          cat > .env << EOF
          NEXTAUTH_SECRET=$_SECRET
          NEXTAUTH_URL=${lib.escapeShellArg authUrl}
          DATABASE_URL=${lib.escapeShellArg databaseURI}
          EOF
          cp -r --no-preserve-mode ${placeholder "out"} $out

          ${yarn}/bin/yarn --offline run prisma migrate deploy
        '';
      start = writeShellScript "${pname}-${version}-start" ''
        cd ${passthru.preStart}
        ${yarn}/bin/yarn start

      '';
    };

  meta = {
    description = "Self-hosted collaborative bookmark manager to collect, organize, and preserve webpages and articles";
    downloadPage = "https://github.com/linkwarden/linkwarden/releases";
    homepage = "https://linkwarden.app/";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
