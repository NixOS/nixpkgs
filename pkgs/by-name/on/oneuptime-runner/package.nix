{
  lib,
  bash,
  buildNpmPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  git,
  makeWrapper,
  nodejs_26,
}:

buildNpmPackage (finalAttrs: {
  pname = "oneuptime-runner";
  version = "12.0.33";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "OneUptime";
    repo = "oneuptime";
    tag = finalAttrs.version;
    hash = "sha256-rbubW94htXyIV6vNxz8YWv4wkMX3a25Dg+IF2aitgMI=";
  };

  sourceRoot = "${finalAttrs.src.name}/Runner";

  nodejs = nodejs_26;

  npmDepsHash = "sha256-5rbZYNqX6cyF13ULg9TWtCXmzk8w4IwZdVhvmJfNEqc=";

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
          src = "${finalAttrs.src}/Common";
          hash = "sha256-rDw1lEtDiqJogkSCZKYaRJQwNqCnGSC6za0pV18RN+c=";
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
        # Runbook steps run under bash, it also supports code fixes which run under git
        lib.makeBinPath [
          bash
          git
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
