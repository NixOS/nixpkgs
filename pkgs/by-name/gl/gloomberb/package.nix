{
  lib,
  stdenv,
  bun,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:
let
  # bun build --compile embeds the OpenTUI native package matching the
  # platform the binary runs on (stdenv.hostPlatform); this mirrors how
  # upstream scripts/build.ts picks it.
  nativePackageFor =
    {
      x86_64-linux = {
        target = "bun-linux-x64";
        nativePackage = "@opentui/core-linux-x64";
      };
      aarch64-linux = {
        target = "bun-linux-arm64";
        nativePackage = "@opentui/core-linux-arm64";
      };
      x86_64-darwin = {
        target = "bun-darwin-x64";
        nativePackage = "@opentui/core-darwin-x64";
      };
      aarch64-darwin = {
        target = "bun-darwin-arm64";
        nativePackage = "@opentui/core-darwin-arm64";
      };
    }
    .${stdenv.hostPlatform.system}
      or (throw "gloomberb: Platform ${stdenv.hostPlatform.system} is not packaged yet.");

  node_modules =
    finalAttrs:
    stdenv.mkDerivation {
      pname = "${finalAttrs.pname}-node_modules";
      inherit (finalAttrs) version src;

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
          --frozen-lockfile \
          --ignore-scripts \
          --no-progress \
          --os="*"

        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall

        mkdir -p $out
        cp -R ./node_modules $out/

        runHook postInstall
      '';

      # The node_modules output is a fixed-output derivation so it can be
      # fetched offline; the hash covers every platform's native packages
      # fetched via --cpu="*" --os="*".
      dontFixup = true;

      outputHash = "sha256-ID6AwV15r+BvGTfRu7aPZN2cozFqyPO2NhqelcfVDPY=";
      outputHashAlgo = "sha256";
      outputHashMode = "recursive";
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gloomberb";
  version = "0.10.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gloom-sh";
    repo = "gloomberb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wGGPV32lk4MteY1gvsR55pL7qtM0TLAapr46zuGr4m4=";
  };

  patches = [
    # Self-update rewrites the binary in place; impossible in the read-only
    # Nix store. Return no update action when running from /nix/store/.
    ./disable-autoupdate.patch
  ];

  nativeBuildInputs = [
    bun
  ];

  configurePhase = ''
    runHook preConfigure

    cp -R ${node_modules finalAttrs}/node_modules .

    runHook postConfigure
  '';

  buildPhase = ''
        runHook preBuild

        mkdir -p dist
        cat > dist/.gloomberb-compile-entry.ts <<'EOF'
    import "${nativePackageFor.nativePackage}";
    import "../src/cli/entry.ts";
    EOF
        bun build \
          --compile \
          --target=${nativePackageFor.target} \
          dist/.gloomberb-compile-entry.ts \
          --outfile=dist/gloomberb

        runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./dist/gloomberb $out/bin/gloomberb

    runHook postInstall
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    codesign --force --sign - $out/bin/gloomberb
  '';

  # strip removes the embedded JS bundle from the binary
  dontStrip = true;

  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];
  versionCheckProgramArg = "version";

  doInstallCheck = true;

  passthru = {
    node_modules = node_modules finalAttrs;
    updateScript = nix-update-script {
      extraArgs = [
        "--subpackage"
        "node_modules"
      ];
    };
  };

  meta = {
    description = "Open-source finance terminal";
    homepage = "https://github.com/gloom-sh/gloomberb";
    changelog = "https://github.com/gloom-sh/gloomberb/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ repparw ];
    mainProgram = "gloomberb";
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
})
