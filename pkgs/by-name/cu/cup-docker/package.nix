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
let
  pname = "cup-docker";
  version = "3.4.3";
  src = fetchFromGitHub {
    owner = "sergi0g";
    repo = "cup";
    tag = "v${version}";
    hash = "sha256-RRhUSL9TR7qr93F5+fyhGW7j6VTs+yVvpni/JHmC5os=";
  };
  web = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "${pname}-web";
    inherit version src;
    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];
    sourceRoot = "${finalAttrs.src.name}/web";
    nativeBuildInputs = [
      bun
      nodejs-slim_latest
    ];
    configurePhase = ''
      runHook preConfigure
      bun install --no-progress --frozen-lockfile
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
    outputHash = "sha256-Ac1PJYmTQv9XrmhmF1p77vdXh8252hz0CUKxJA+VQR4=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  });
in
rustPlatform.buildRustPackage {
  inherit
    src
    version
    pname
    ;

  cargoHash = "sha256-1VSbv6lDRRLZIu7hYrAqzQmvxcuhnPU0rcWfg7Upcm4=";

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "cli"
  ]
  ++ lib.optional withServer [
    "server"
  ];

  preConfigure = lib.optionalString withServer ''
    cp -r ${web}/dist src/static
  '';

  passthru = {
    inherit web;
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
}
