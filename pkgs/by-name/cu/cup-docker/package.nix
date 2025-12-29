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
    bunDeps = bun.fetchDeps {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-wxkF4JCN6+5dyMTPkH3b/TQbdguiCIyx7OBIRE+k0YE=";
    };

    sourceRoot = "${finalAttrs.src.name}/web";
    nativeBuildInputs = [
      bun.configHook
      nodejs-slim_latest
    ];

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
