{
  lib,
  bash,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  git,
  kubectl,
  makeWrapper,
  nodejs_26,
}:

buildNpmPackage (finalAttrs: {
  pname = "oneuptime-runner";
  version = "14.0.28";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-WeW9HxGNyR+Zh6M6e2lPgwHqHAjovxDROVsvYyEiY+s=";
  };

  sourceRoot = "${finalAttrs.src.name}/packages/Runner";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-19tVugbmUXPo+5Xk0L6C4kMIB0YtjO1WF290vDqxey4=";

  nativeBuildInputs = [ makeWrapper ];

  # unpackPhase only makes sourceRoot writable, and Common sits outside it.
  postPatch = ''
    chmod -R u+w ..
  '';

  # Runner depends on Common as `file:../Common`, so npm symlinks it rather than installing it.
  preBuild = ''
    (
      cd ../Common
      export npmDeps=${
        fetchNpmDeps {
          name = "oneuptime-common-npm-deps-${finalAttrs.version}";
          src = "${finalAttrs.src}/packages/Common";
          hash = "sha256-4Wew9NXz1ieeyKWDEQrxIr0aNP8n2TtPB5ynIiuy+Po=";
        }
      }
      npmConfigHook
    )
  '';

  dontNpmBuild = true;

  installPhase = ''
    runHook preInstall

    install -d $out/lib/oneuptime
    cp -a ../Common $out/lib/oneuptime/Common
    cp -a . $out/lib/oneuptime/Runner

    makeWrapper ${lib.getExe nodejs_26} $out/bin/oneuptime-runner \
      --chdir $out/lib/oneuptime/Runner \
      --add-flags "--no-node-snapshot --require ts-node/register $out/lib/oneuptime/Runner/Index.ts" \
      --set TS_NODE_TRANSPILE_ONLY 1 \
      --set APP_VERSION ${finalAttrs.version} \
      --prefix PATH : ${
        # Runbook steps run under bash, it also supports code fixes which run under git and AI cluster access which runs under kubectl
        lib.makeBinPath [
          bash
          git
          kubectl
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Self-hosted agent that runs OneUptime runbook steps and AI code fixes inside your own infrastructure";
    homepage = "https://github.com/OneUptime/oneuptime";
    changelog = "https://github.com/OneUptime/oneuptime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "oneuptime-runner";
    platforms = lib.platforms.linux;
  };
})
