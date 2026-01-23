{
  lib,
  stdenv,
  stdenvNoCC,
  bun,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}: let
  pname = "better-context";
  version = "1.0.51";

  src = fetchFromGitHub {
    owner = "davis7dotsh";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-N8fZBnA7HGz89Oj3cnjEMCd3koo/Dm07yoeUTlRGlyI=";
  };

  # Platform-specific mapping
  platformMap = {
    "x86_64-linux" = {
      bunTarget = "bun-linux-x64";
      binary = "btca-linux-x64";
    };
    "aarch64-linux" = {
      bunTarget = "bun-linux-arm64";
      binary = "btca-linux-arm64";
    };
    "x86_64-darwin" = {
      bunTarget = "bun-darwin-x64";
      binary = "btca-darwin-x64";
    };
    "aarch64-darwin" = {
      bunTarget = "bun-darwin-arm64";
      binary = "btca-darwin-arm64";
    };
  };

  platformInfo =
    platformMap.${stdenv.hostPlatform.system}
    or (throw "Unsupported platform: ${stdenv.hostPlatform.system}");

  node_modules = stdenvNoCC.mkDerivation {
    pname = "${pname}-node_modules";
    inherit version src;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;

    buildPhase = ''
      runHook preBuild

      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      find . -type d -name node_modules -exec cp -R --parents {} $out \;

      runHook postInstall
    '';

    dontFixup = true;

    outputHash = "sha256-BfTb6RoZvWX5g6+rHagVDyX7PzBheQK47UL0Wmb7HrM=";
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    inherit pname version src node_modules;

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    configurePhase = ''
      runHook preConfigure

      cp -R ${node_modules}/. .

      chmod -R u+w node_modules/.bin 2>/dev/null || true
      rm -f node_modules/.bin/turbo

      cp ${./build-binaries.ts} apps/cli/scripts/build-binaries.ts

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      bun run --cwd apps/cli scripts/build-binaries.ts ${platformInfo.bunTarget} ${version}

      runHook postBuild
    '';

    # Don't strip the binary - it breaks bun compiled executables
    dontStrip = true;

    installPhase = ''
      runHook preInstall

      # Install the platform-specific binary
      install -Dm755 apps/cli/dist/${platformInfo.binary} $out/bin/btca

      runHook postInstall
    '';

    nativeInstallCheckInputs = [
      versionCheckHook
      writableTmpDirAsHomeHook
    ];
    doInstallCheck = true;
    versionCheckProgramArg = "--version";
    versionCheckKeepEnvironment = ["HOME"];

    passthru = {
      updateScript = nix-update-script {
        extraArgs = [
          "--subpackage"
          "node_modules"
        ];
      };
    };

    meta = {
      description = "A better way to get up to date context on libraries/technologies in your projects";
      homepage = "https://github.com/davis7dotsh/better-context";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [EloToJaa];
      sourceProvenance = with lib.sourceTypes; [fromSource];
      platforms = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      mainProgram = "btca";
    };
  })
