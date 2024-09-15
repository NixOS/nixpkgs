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
  writers,
}:
let
  linkwarden = mkYarnPackage rec {
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
    patches = [ ./patches/0001.executable.diff ];
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
        dataStoragePath,
      }:
      let
        commonEnvironment = ''
          export PRISMA_MIGRATION_ENGINE_BINARY="${prisma-engines}/bin/schema-engine"
          export PRISMA_QUERY_ENGINE_BINARY="${prisma-engines}/bin/query-engine"
          export PRISMA_QUERY_ENGINE_LIBRARY="${prisma-engines}/lib/libquery_engine.node"
          export PRISMA_INTROSPECTION_ENGINE_BINARY="${prisma-engines}/bin/introspection-engine"
          export PRISMA_FMT_BINARY="${prisma-engines}/bin/prisma-fmt"
        '';
        preStart =
          let
            localSecret = if secret != null then secret else ''cat ${secretFile}'';
          in
          runCommand "${pname}-${version}-wrapped" { meta = placeholder "meta"; } ''
            ${commonEnvironment}
            export HOME=/var/lib/linkwarden
            _SECRET=${localSecret}
            cat > .env << EOF
            NEXTAUTH_SECRET=$_SECRET
            NEXTAUTH_URL=${authUrl}
            DATABASE_URL=${databaseURI}
            EOF
            cp -r --no-preserve=mode ${linkwarden} $out
            ln -s "${dataStoragePath}" $out/data
            chmod a+x \
              $out/node_modules/prisma/build/index.js \
              $out/node_modules/.bin/playwright \
              $out/node_modules/.bin/next
            find $out/node_modules/.bin -type f -exec chmod a+x {} \;
          '';
      in
      {
        rootFolder = preStart.outPath;
        preStartScript = writers.writeBash "${pname}-${version}-preStart" ''
          cd ${preStart.outPath}
          ${commonEnvironment}
          ${yarn}/bin/yarn --offline run prisma migrate deploy
        '';
        startScript = writers.writeBash "${pname}-${version}-start" ''
          cd ${preStart.outPath}
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
  };
in
linkwarden
