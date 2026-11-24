{
  lib,
  stdenv,
  bun,
  darwin,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  ripgrep,
  sysctl,
  versionCheckHook,
  wayland,
  writableTmpDirAsHomeHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "2.3.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7vw0TcaFsMN+XbZoU1gwHE1r8ppPPK0CTQqPbVQozT8=";
  };

  bunWorkspaces = [ "./packages/opencode" ];
  bunDeps = bun.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      bunWorkspaces
      ;
    hash = "";

  };

  nativeBuildInputs = [
    bun.configHook
    installShellFiles
    makeBinaryWrapper
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  env = {
    MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
    OPENCODE_DISABLE_MODELS_FETCH = true;
    OPENCODE_VERSION = finalAttrs.version;
    OPENCODE_CHANNEL = "latest";
    NODE_OPTIONS = "--max-old-space-size=4096";
  };

  postPatch =
    # Relax Bun version check to be a warning instead of an error
    ''
      substituteInPlace packages/script/src/index.ts \
        --replace-fail \
        'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
        'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
    ''
    # Avoid requiring prettier just to format the schema JSON
    + ''
      substituteInPlace packages/cli/script/schema.ts \
        --replace-fail 'import { format } from "prettier"' 'const format = (s: string) => JSON.stringify(JSON.parse(s), null, 2)'
    '';

  buildPhase = ''
    runHook preBuild

    cd ./packages/cli
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts cli.json
    bun --bun ../schema/script/config-schema.ts config.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/cli-*/bin/opencode $out/bin/opencode

    wrapArgs=(
      --set OPENCODE_DISABLE_AUTOUPDATE true
      --suffix PATH : ${lib.makeBinPath [ ripgrep ]}
    )
    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapArgs+=(--prefix PATH : ${lib.makeBinPath [ sysctl ]})
    ''}
    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapArgs+=(--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          stdenv.cc.cc
          wayland
        ]
      })
    ''}

    wrapProgram $out/bin/opencode "''${wrapArgs[@]}"

    install -Dm644 cli.json $out/share/cli.json
    install -Dm644 config.json $out/share/config.json
    install -Dm644 ../../services/site/public/v1/docs/theme.json $out/share/theme.json

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd opencode \
      --bash <($out/bin/opencode --completions bash) \
      --zsh <($out/bin/opencode --completions zsh) \
      --fish <($out/bin/opencode --completions fish)
  '';

  dontStrip = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  doInstallCheck = true;
  versionCheckKeepEnvironment = [
    "HOME"
    "OPENCODE_DISABLE_MODELS_FETCH"
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    jsonschema = {
      cli = "${finalAttrs.finalPackage}/share/cli.json";
      config = "${finalAttrs.finalPackage}/share/config.json";
      theme = "${finalAttrs.finalPackage}/share/theme.json";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    changelog = "https://github.com/anomalyco/opencode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      delafthi
      DuskyElf
      graham33
      xiaoxiangmoe
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
    ];
    mainProgram = "opencode";
  };
})
