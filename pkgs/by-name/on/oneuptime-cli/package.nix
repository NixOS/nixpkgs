{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  makeWrapper,
  nodejs_26,
  versionCheckHook,
}:

buildNpmPackage (finalAttrs: {
  pname = "oneuptime-cli";
  version = "14.0.10";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-AcbAL+jsYsEoSIcIcWU2xypWt232Fi/5+bVt0Unnojk=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/CLI";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-Ue2FqYPEtkxRAvWaoNxgivCEKhlU9NO4OUoL5PmAVuM=";

  nativeBuildInputs = [
    makeWrapper
    versionCheckHook
  ];

  # unpackPhase only makes sourceRoot writable, and Common sits outside it.
  postPatch = ''
    chmod -R u+w ..
  '';

  # CLI depends on Common as `file:../Common`, so npm symlinks it rather than installing it.
  preBuild = ''
    (
      cd ../Common
      export npmDeps=${
        fetchNpmDeps {
          name = "oneuptime-common-npm-deps-${finalAttrs.version}";
          src = "${finalAttrs.src}/packages/Common";
          hash = "sha256-APolLZbF0BWeN/bkSMelVOjc4TUEBlwcPcniq5+Ba1Y=";
        }
      }
      npmConfigHook
    )
  '';

  # Common is TypeScript only, so the CLI runs through ts-node like upstream's `npm start`.
  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    install -d $out/lib/oneuptime
    cp -a ../Common $out/lib/oneuptime/Common
    cp -a . $out/lib/oneuptime/CLI

    # No --chdir: the CLI only reads ~/.oneuptime. But node resolves --require
    # and ts-node resolves tsconfig.json from the cwd, so give both absolute paths.
    makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime \
      --add-flags "--require $out/lib/oneuptime/CLI/node_modules/ts-node/register $out/lib/oneuptime/CLI/Index.ts" \
      --set TS_NODE_PROJECT $out/lib/oneuptime/CLI/tsconfig.json \
      --set TS_NODE_TRANSPILE_ONLY 1

    runHook postInstall
  '';

  versionCheckProgramArg = "version";

  meta = {
    description = "Command-line interface for managing OneUptime resources";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime";
    platforms = lib.platforms.linux;
  };
})
