{
  lib,
  stdenv,
  fetchFromGitHub,
  yarnConfigHook,
  yarnBuildHook,
  yarnInstallHook,
  fetchYarnDeps,
  makeBinaryWrapper,
  nodejs,
  prettier,
}: stdenv.mkDerivation
  (finalAttrs: {
    pname = "prettier-java";
    version = "2.9.2";

    src = fetchFromGitHub {
      owner = "jhipster";
      repo = "prettier-java";
      tag = "prettier-plugin-java@${finalAttrs.version}";
      hash = "sha256-Sdd7nE1mgz05W6FF8BSTPbuhcJCnV/rGzrySJSLAT7w=";
    };

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = finalAttrs.src + "/yarn.lock";
      hash = "sha256-Y3QCh9Dv17eROlZB7Fd8z0io7cbgHasBbK+IgrCCWkY=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      yarnBuildHook
      yarnInstallHook
      # Needed for executing package.json scripts
      nodejs
    ];

    buildInputs = [
      makeBinaryWrapper
    ];

    installPhase = ''
      runHook yarnInstall

      #Dependancies
      mkdir -p $out/lib
      cp -r ./node_modules $out/lib

      #Out File
      cp -r dist $out/

      makeBinaryWrapper "${lib.getExe prettier}" "$out/bin/prettier-java" \
        --set NODE_PATH "$out/lib/node_modules" \
        --add-flags "--plugin" \
        --add-flags "$out/dist/index.cjs"
    '';
    
    meta = {
      description = "Prettier with prettier-java preloaded";
      license = lib.licensesSpdx."Apache-2.0";
      mainProgram = "prettier-java";
      maintainers = [
        lib.maintainers.minksd
      ];
    };
  })
