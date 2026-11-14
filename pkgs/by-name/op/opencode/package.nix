{
  lib,
  stdenv,
  bun,
  darwin,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  models-dev,
  nodejs,
  nix-update-script,
  ripgrep,
  sysctl,
  versionCheckHook,
  wayland,
  writableTmpDirAsHomeHook,
}:
let
  node_modules =
    finalAttrs:
    let
      # opencode runs on Linux and Darwin only (see meta.platforms), but
      # "--os=*" installs every other platform's prebuilts as well: 1.30 GiB of
      # them on Linux (Darwin binaries plus win32/android/freebsd/aix/...) and
      # 1.69 GiB on Darwin. That is what pushed this fixed-output derivation
      # past Hydra's output limit, which is why no opencode build has reached
      # cache.nixos.org since 2.2.1 (NixOS/nixpkgs#585600). Every CPU variant is
      # still installed, so the output stays byte-identical across architectures
      # of one OS and the per-OS outputHash below still covers all of them; a
      # cross build of either OS gets the target's prebuilts from --cpu="*" too.
      installOs = if stdenv.hostPlatform.isDarwin then "darwin" else "linux";
    in
    stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

      __structuredAttrs = true;
      strictDeps = true;

      impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
        "GIT_PROXY_COMMAND"
        "SOCKS_SERVER"
      ];

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild

        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install \
          --cpu="*" \
          --filter './' \
          --filter './packages/cli' \
          --filter './packages/desktop' \
          --filter './packages/app' \
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --os="${installOs}"

        bun --bun ./nix/scripts/canonicalize-node-modules.ts
        bun --bun ./nix/scripts/normalize-bun-binaries.ts

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        find . -type d -name node_modules -exec cp -R --parents {} $out \;

        # electron-winstaller and @electron/windows-sign vendor Windows
        # executables in their tarballs, so --os does not drop them. opencode
        # targets Linux and Darwin only (see meta.platforms) and never executes
        # them, so dropping them keeps the output reproducible on hosts whose
        # security endpoint agents scan the store, and removes the vulnerable
        # 7z-*.exe that will be quarantined.
        find $out -type f -name '*.exe' -delete

        runHook postInstall
      '';

      # NOTE: Required else we get errors that our fixed-output derivation references store paths
      dontFixup = true;

      outputHash =
        if stdenv.hostPlatform.isLinux then
          "sha256-0CWBsiROlt+gxw3NPIR73FQTzn2ku/2ET/bOwP1+XMg="
        else if stdenv.hostPlatform.isDarwin then
          "sha256-lRvSbgFjbv/wXuoUWkWmMAtd3owJNfYHL1GP+HhStTY="
        else
          throw "Unsupported platform";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "opencode";
  version = "2.2.6";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "anomalyco";
    repo = "opencode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6Of4/r4SKYtxMbHISu8/4yzSpCfHNGuTwfKdAKjNJnM=";
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

  node_modules = node_modules finalAttrs;

  nativeBuildInputs = [
    bun
    installShellFiles
    makeBinaryWrapper
    nodejs
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

  configurePhase = ''
    runHook preConfigure

    cp -R "$node_modules"/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
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
    install -Dm644 ../web/public/theme.json $out/share/theme.json

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
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
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
