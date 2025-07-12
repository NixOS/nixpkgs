{
  rustPlatform,
  fetchFromGitHub,
  lib,
  stdenvNoCC,
  bun,
  nodejs-slim_latest,
  nix-update-script,
  withServer ? true,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cup-docker";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "sergi0g";
    repo = "cup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ciH3t2L2eJhk1+JXTqEJSuHve8OuVod7AuQ3iFWmKRE=";
  };

  web = lib.optionalDrvAttr withServer (
    stdenvNoCC.mkDerivation {
      pname = "${finalAttrs.pname}-web";

      inherit (finalAttrs) version src;
      sourceRoot = "${finalAttrs.src.name}/web";

      outputHash = "sha256-Ac1PJYmTQv9XrmhmF1p77vdXh8252hz0CUKxJA+VQR4=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      nativeBuildInputs = [
        bun
        nodejs-slim_latest
      ];

      configurePhase = ''
        runHook preConfigure

        bun install --no-progress --frozen-lockfile
        # patchShebangs doesn't work
        substituteInPlace node_modules/.bin/{vite,tsc} \
          --replace-fail "/usr/bin/env node" "${nodejs-slim_latest}/bin/node"

        runHook postConfigure
      '';

      buildPhase = ''
        runHook preBuild

        bun run build

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out/dist
        cp -R ./dist $out

        runHook postInstall
      '';
    }
  );

  cargoHash = "sha256-L9zugOwlPwpdtjV87dT1PH7FAMJYHYFuvfyOfPe5b2k=";

  buildNoDefaultFeatures = true;
  buildFeatures =
    [
      "cli"
    ]
    ++ lib.optionals withServer [
      "server"
    ];

  preConfigure = lib.optionalString withServer ''
    cp -r $web/dist src/static
  '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "web"
      ];
    };
  };

  meta = {
    description = "Lightweight tool written in Rust to check for container image updates";
    homepage = "https://cup.sergi0g.dev";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    changelog = "https://github.com/sergi0g/cup/releases";
    mainProgram = "cup";
    maintainers = with lib.maintainers; [
      kuflierl
    ];
  };
})
