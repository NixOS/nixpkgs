{
  lib,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  makeBinaryWrapper,
  models-dev,
  nix-update-script,
  ripgrep,
  sysctl,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "1.4.11";

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jlxR2BODV8wk0sP4Kkyza7Zr5I+Q003gldCfp2eYOt8=";
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
    models-dev
    writableTmpDirAsHomeHook
  ];

  postPatch = ''
    # NOTE: Relax Bun version check to be a warning instead of an error
    substituteInPlace packages/script/src/index.ts \
      --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                     'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
  '';

  env.MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
  env.OPENCODE_DISABLE_MODELS_FETCH = true;
  env.OPENCODE_VERSION = finalAttrs.version;
  env.OPENCODE_CHANNEL = "stable";

  buildPhase = ''
    runHook preBuild

    cd ./packages/opencode
    bun --bun ./script/build.ts --single --skip-install
    bun --bun ./script/schema.ts config.json tui.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 dist/opencode-*/bin/opencode $out/bin/opencode
    wrapProgram $out/bin/opencode \
     --prefix PATH : ${
       lib.makeBinPath (
         [
           ripgrep
         ]
         ++ lib.optionals stdenvNoCC.hostPlatform.isDarwin [
           sysctl
         ]
       )
     }

    install -Dm644 config.json $out/share/opencode/config.json
    install -Dm644 tui.json $out/share/opencode/tui.json

    runHook postInstall
  '';

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd opencode \
      --bash <($out/bin/opencode completion) \
      --zsh <(SHELL=/bin/zsh $out/bin/opencode completion)
  '';

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
      config = "${placeholder "out"}/share/opencode/config.json";
      tui = "${placeholder "out"}/share/opencode/tui.json";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "AI coding agent built for the terminal";
    homepage = "https://github.com/anomalyco/opencode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      delafthi
      DuskyElf
      graham33
      superherointj
    ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "opencode";
    badPlatforms = [
      # Broken as 2026-04-23, errors as:
      # CPU lacks AVX support, strange crashes may occur. Reinstall Bun
      "x86_64-darwin"
    ];
  };
})
