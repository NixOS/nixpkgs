{
  lib,
  fetchFromGitHub,
  stdenv,
  nodejs,
  pnpm_10,
  prisma-engines_7,
  jq,
  makeWrapper,
  moreutils,
  callPackage,
  pnpmConfigHook,
  fetchPnpmDeps,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prisma_7";
  version = "7.3.0";

  src = fetchFromGitHub {
    owner = "prisma";
    repo = "prisma";
    tag = finalAttrs.version;
    hash = "sha256-X3tLHUJ+tSjo4DPgmo43KMXHPP5BZK14kCj7sBgjPu8=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    jq
    makeWrapper
    moreutils
    pnpm_10
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-HkEoPY0rrRZL53EI1NupnWnCMvtcViSVA2GIiwBr8wo=";
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
    find . -name node_modules -type d -prune -exec rm -rf {} +
    pnpm install --offline --ignore-scripts --frozen-lockfile --prod
    cp -r node_modules $out/lib/prisma

    # Resolve workspace references so pnpm pack works
    for package in packages/*; do
      jq --arg version $version '
        def resolve_deps: with_entries(.value |= if . == "workspace:*" then $version else . end);
        if has("dependencies") then .dependencies |= resolve_deps else . end
        | if has("devDependencies") then .devDependencies |= resolve_deps else . end
      ' $package/package.json | sponge $package/package.json
    done

    # Only install cli and its workspace dependencies
    for package in cli $deps; do
      filename=$(cd packages/$package && pnpm pack | tail -1)
      mkdir -p $out/lib/prisma/packages/$package
      [ -d "packages/$package/node_modules" ] && \
        cp -r packages/$package/node_modules $out/lib/prisma/packages/$package
      tar xf "packages/$package/$filename" --strip-components=1 -C $out/lib/prisma/packages/$package
    done

    # Remove dangling symlinks to packages we didn't copy to $out
    find $out/lib/prisma/node_modules/.pnpm/node_modules -type l -exec test ! -e {} \; -delete

    makeWrapper "${lib.getExe nodejs}" "$out/bin/prisma" \
      --add-flags "$out/lib/prisma/packages/cli/build/index.js" \
      --set PRISMA_SCHEMA_ENGINE_BINARY ${prisma-engines_7}/bin/schema-engine

    runHook postInstall
  '';

  dontStrip = true;

  passthru.tests = {
    cli = callPackage ./test-cli.nix { };
  };

  meta = {
    description = "Next-generation ORM for Node.js and TypeScript";
    homepage = "https://www.prisma.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aqrln ];
    mainProgram = "prisma";
    platforms = lib.platforms.unix;
  };
})
