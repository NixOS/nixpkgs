{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  faketty,
  openssl,
<<<<<<< HEAD
  prisma_6,
  prisma-engines_6,
=======
  prisma,
  prisma-engines,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildNpmPackage rec {
  pname = "ghostfolio";
<<<<<<< HEAD
  version = "2.225.0";
=======
  version = "2.219.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ghostfolio";
    repo = "ghostfolio";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-nzXQfi4N7t/tm5Zub29AIYKgBYzZN8k/fPLqRK3PKwM=";
=======
    hash = "sha256-WXBKUvwfllH6HQFgUBcUSaaHqhMrWU3V969ZtJ9y7KQ=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    # populate values that require us to use git. By doing this in postFetch we
    # can delete .git afterwards and maintain better reproducibility of the src.
    leaveDotGit = true;
    postFetch = ''
      date -u -d "@$(git -C $out log -1 --pretty=%ct)" +%s%3N > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

<<<<<<< HEAD
  npmDepsHash = "sha256-TADFJd6kWmEsXi9+04OAGlhR2rX+++K5OraaQatLSho=";

  nativeBuildInputs = [
    prisma_6
=======
  npmDepsHash = "sha256-Xn+8+CHgCQ6Zh2/HUbl1xW8LkIypCfHAFzflc6vIeKQ=";

  nativeBuildInputs = [
    prisma
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    faketty
  ];

  # Disallow cypress from downloading binaries in sandbox
  env.CYPRESS_INSTALL_BINARY = "0";

  buildPhase = ''
    runHook preBuild

    prisma generate

    substituteInPlace replace.build.mjs \
      --replace-fail 'new Date()' "new Date(''$(<SOURCE_DATE_EPOCH))"

    # Workaround for https://github.com/nrwl/nx/issues/22445
    faketty npm run build:production

    cp -r node_modules dist/apps/api/
    cp -r prisma dist/apps/api/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/node_modules/ghostfolio"
    cp -r dist/apps/{api,client} "$out/lib/node_modules/ghostfolio/"

    mkdir "$out/bin"
    makeWrapper ${lib.getExe nodejs} "$out/bin/ghostfolio" \
      --add-flags "$out/lib/node_modules/ghostfolio/api/main" "''${user_args[@]}" \
      --prefix PATH : ${lib.makeBinPath [ openssl ]} \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ openssl ]} \
      ${lib.concatStringsSep " " (
        lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") {
<<<<<<< HEAD
          PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines_6 "schema-engine";
          PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines_6 "query-engine";
          PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines_6}/lib/libquery_engine.node";
          PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines_6 "introspection-engine";
          PRISMA_FMT_BINARY = lib.getExe' prisma-engines_6 "prisma-fmt";
=======
          PRISMA_SCHEMA_ENGINE_BINARY = lib.getExe' prisma-engines "schema-engine";
          PRISMA_QUERY_ENGINE_BINARY = lib.getExe' prisma-engines "query-engine";
          PRISMA_QUERY_ENGINE_LIBRARY = "${prisma-engines}/lib/libquery_engine.node";
          PRISMA_INTROSPECTION_ENGINE_BINARY = lib.getExe' prisma-engines "introspection-engine";
          PRISMA_FMT_BINARY = lib.getExe' prisma-engines "prisma-fmt";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
        }
      )}

    runHook postInstall
  '';

  meta = {
    description = "Open Source Wealth Management Software";
    homepage = "https://github.com/ghostfolio/ghostfolio";
    changelog = "https://github.com/ghostfolio/ghostfolio/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "ghostfolio";
  };
}
