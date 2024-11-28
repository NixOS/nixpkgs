{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
  pnpm_8,
  prisma-engines,
  jq,
  makeWrapper,
  moreutils,
  callPackage,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prisma";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma";
    rev = finalAttrs.version;
    hash = "sha256-mwGFuJLry2WvwLclRw+ulMVgp8tfZbhzrdgKjQ4D7LE=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
    jq
    makeWrapper
    moreutils
  ];

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-fOg32w/fQkyn8HBMffUKob7XzOQLtsB642pDdEz/y2E=";
  };

  patchPhase = ''
    runHook prePatch

    for package in packages/*; do
      jq --arg version $version '.version = $version' $package/package.json | sponge $package/package.json
    done

    runHook postPatch
  '';

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  # FIXME: Use pnpm deploy: https://github.com/pnpm/pnpm/issues/5315
  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/prisma

    # Fetch CLI workspace dependencies
    deps_json=$(pnpm list --filter ./packages/cli --prod --depth Infinity --json)
    deps=$(jq -r '[.. | strings | select(startswith("link:../")) | sub("^link:../"; "")] | unique[]' <<< "$deps_json")

    # Remove unnecessary external dependencies
    rm -rf node_modules
    pnpm install --offline --ignore-scripts --frozen-lockfile --prod --filter ./packages/cli
    cp -r node_modules $out/lib/prisma

    # Only install cli and its workspace dependencies
    for package in cli $deps; do
      filename=$(npm pack --json ./packages/$package | jq -r '.[].filename')
      mkdir -p $out/lib/prisma/packages/$package
      cp -r packages/$package/node_modules $out/lib/prisma/packages/$package
      tar xf $filename --strip-components=1 -C $out/lib/prisma/packages/$package
    done

    makeWrapper "${lib.getExe nodejs}" "$out/bin/prisma" \
      --add-flags "$out/lib/prisma/packages/cli/build/index.js" \
      --set PRISMA_SCHEMA_ENGINE_BINARY ${prisma-engines}/bin/schema-engine \
      --set PRISMA_QUERY_ENGINE_BINARY ${prisma-engines}/bin/query-engine \
      --set PRISMA_QUERY_ENGINE_LIBRARY ${lib.getLib prisma-engines}/lib/libquery_engine.node

    runHook postInstall
  '';

  dontStrip = true;

  passthru.tests = {
    cli = callPackage ./test-cli.nix { };
  };

  meta = with lib; {
    description = "Next-generation ORM for Node.js and TypeScript";
    homepage = "https://www.prisma.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ aqrln ];
    platforms = platforms.unix;
  };
})
