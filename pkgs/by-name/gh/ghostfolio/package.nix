{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  faketty,
  openssl,
  prisma_7,
  prisma-engines_7,
  runtimeShell,
}:

buildNpmPackage (finalAttrs: {
  pname = "ghostfolio";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "ghostfolio";
    repo = "ghostfolio";
    tag = finalAttrs.version;
    hash = "sha256-74CqCDyLrn3//FiTfo6xR5jLyo4jU+daBF9ES/uQE3E=";
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" +%s%3N > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  npmDepsHash = "sha256-klWmB6LYf6h1WPi3AasDrdVdaPCyb5ePWuO9zqMcXys=";

  postPatch = ''
    substituteInPlace replace.build.mjs \
      --replace-fail 'new Date()' "new Date(''$(<SOURCE_DATE_EPOCH))"
    # SyntaxError: Named export 'PrismaClient' not found
    substituteInPlace prisma/seed.mts \
      --replace-fail "import { PrismaClient } from '@prisma/client';" \
        "import prismaClientPkg from '@prisma/client'; const { PrismaClient } = prismaClientPkg;"
    # storybook output is not used, skip it
    substituteInPlace package.json --replace-fail "nx run ui:build-storybook" "true"
  '';

  nativeBuildInputs = [
    prisma_7
    faketty
  ];

  # Disallow cypress from downloading binaries in sandbox
  env.CYPRESS_INSTALL_BINARY = "0";

  buildPhase = ''
    runHook preBuild

    prisma generate

    # Workaround for https://github.com/nrwl/nx/issues/22445
    faketty npm run build:production

    npm prune --omit=dev --no-save

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r {node_modules,prisma} dist/apps/api/

    mkdir -p $out/lib/ghostfolio
    cp -r dist/apps/{api,client} "$out/lib/ghostfolio/"

    substituteInPlace .config/prisma.ts \
      --replace-fail "__dirname, '..', 'prisma'" "'$out/lib/ghostfolio/api/prisma'" \
      --replace-fail "node " "${lib.getExe nodejs} "
    install -Dm444 .config/prisma.ts "$out/lib/ghostfolio/api/prisma.config.ts"

    makeWrapper ${lib.getExe nodejs} "$out/bin/ghostfolio" \
      --add-flags "$out/lib/ghostfolio/api/main" "''${user_args[@]}" \
      --prefix PATH : ${lib.makeBinPath [ openssl ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]} \
      ${lib.concatStringsSep " " (
        lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") {
          PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines_7 "schema-engine";
          PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines_7 "query-engine";
          PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines_7}/lib/libquery_engine.node";
          PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines_7 "introspection-engine";
          PRISMA_FMT_BINARY = lib.getExe' prisma-engines_7 "prisma-fmt";
        }
      )}

    cat > $out/bin/ghostfolio-migrate <<EOF
    #!${runtimeShell}
    set -euo pipefail
    ${lib.getExe prisma_7} migrate deploy --config "$out/lib/ghostfolio/api/prisma.config.ts"
    ${lib.getExe prisma_7} db seed --config "$out/lib/ghostfolio/api/prisma.config.ts"
    EOF
    chmod +x $out/bin/ghostfolio-migrate

    # For compatibility
    mkdir -p $out/lib/node_modules
    ln -sr $out/lib/ghostfolio $out/lib/node_modules/ghostfolio

    runHook postInstall
  '';

  # Remove dev deps not needed at runtime
  preFixup = ''
    find $out/lib -name "*.py" -delete
    apiModules="$out/lib/ghostfolio/api/node_modules"
    rm -rf \
      "$out/lib/ghostfolio/client/development" \
      "$apiModules"/sass-embedded* \
      "$apiModules"/{@,}esbuild \
      "$apiModules"/{@,}rollup \
      "$apiModules"/@rolldown \
      "$apiModules"/@parcel/watcher-* \
      "$apiModules"/typescript \
      "$apiModules"/.{bin,cache} \
  '';

  meta = {
    description = "Open Source Wealth Management Software";
    homepage = "https://github.com/ghostfolio/ghostfolio";
    changelog = "https://github.com/ghostfolio/ghostfolio/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "ghostfolio";
  };
})
