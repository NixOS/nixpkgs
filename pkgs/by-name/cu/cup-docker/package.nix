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
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "sergi0g";
    repo = "cup";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l7TQwCzQNwrsM+xRcRcQaxIsnd8SVzrqEMwIoZGVBR0=";
  };
  web = stdenvNoCC.mkDerivation (finalAttrsWeb: {
    pname = "${finalAttrs.pname}-web";
    inherit (finalAttrs) version src;
    bunDeps = bun.fetchDeps {
      inherit (finalAttrsWeb)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-ueQXZnPn97lUkxGtSdliDIgDiXd/Uwa5I/tWZvG/yZQ=";
    };

    sourceRoot = "${finalAttrs.src.name}/web";
    nativeBuildInputs = [
      bun.configHook
      nodejs-slim_latest
    ];

    patchPhase = ''
      runHook preConfigure
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
  });

  cargoHash = "sha256-1VSbv6lDRRLZIu7hYrAqzQmvxcuhnPU0rcWfg7Upcm4=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "cli"
  ]
  ++ lib.optional withServer [
    "server"
  ];

  preConfigure = lib.optionalString withServer ''
    cp -r ${finalAttrs.web}/dist src/static
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
    description = "Lightweight way to check for container image updates. written in Rust";
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
