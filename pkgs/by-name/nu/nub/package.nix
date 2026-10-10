{
  autoPatchelfHook,
  common-updater-scripts,
  curl,
  fetchurl,
  installShellFiles,
  jq,
  lib,
  makeWrapper,
  stdenv,
  stdenvNoCC,
  writeShellScript,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  pname = "nub";

  version = "0.2.3";

  src =
    finalAttrs.passthru.sources.${stdenvNoCC.hostPlatform.system}
      or (throw "Unsupported system: ${stdenvNoCC.hostPlatform.system}");

  sourceRoot = ".";

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  # The prebuilt Linux binary and nub-native.node link glibc (libc, libm, libgcc_s)
  # and hard-code a /lib64 interpreter — autoPatchelfHook rewrites both for the Nix store.
  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    stdenv.cc.libc
  ];

  dontConfigure = true;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r bin "$out/bin"
    cp -r runtime "$out/runtime"
    chmod +x "$out/bin/nub" "$out/bin/nubx"

    runHook postInstall
  '';

  passthru = {
    sources = {
      "x86_64-linux" = fetchurl {
        url = "https://github.com/nubjs/nub/releases/download/v${finalAttrs.version}/nub-linux-x64.tar.gz";
        hash = "sha256-QPUUjsQZiKI79tIu1mc6nAq2nAhOrtqiQaw2pZf4g9s=";
      };
      "aarch64-linux" = fetchurl {
        url = "https://github.com/nubjs/nub/releases/download/v${finalAttrs.version}/nub-linux-arm64.tar.gz";
        hash = "sha256-lEHMcwyw/fWswHYrKW+ZfyWQ4O0acco8qWqSo0p6hVI=";
      };
      "x86_64-darwin" = fetchurl {
        url = "https://github.com/nubjs/nub/releases/download/v${finalAttrs.version}/nub-darwin-x64.tar.gz";
        hash = "sha256-b4+lsazFqgR9FEfR6T0F1GrNQUbKMyokiSUttSk7MA0=";
      };
      "aarch64-darwin" = fetchurl {
        url = "https://github.com/nubjs/nub/releases/download/v${finalAttrs.version}/nub-darwin-arm64.tar.gz";
        hash = "sha256-tVDiXNEZ25XJ1W+xTOyXKVbh2DXOoVIoyGJc0TzXf5Q=";
      };
    };

    tests = {
      version = stdenvNoCC.mkDerivation {
        name = "nub-version-test";

        buildInputs = [ finalAttrs.finalPackage ];

        dontBuild = true;

        dontConfigure = true;

        dontUnpack = true;

        installPhase = ''
          mkdir -p $out

          if ! nub --version | grep -q v${finalAttrs.version}; then
            echo "nub --version output incorrect"

            exit 1
          fi

          if ! nubx --version | grep -q v${finalAttrs.version}; then
            echo "nubx --version output incorrect"

            exit 1
          fi
        '';
      };
    };

    updateScript = writeShellScript "update-nub" ''
      set -o errexit

      export PATH="${
        lib.makeBinPath [
          common-updater-scripts
          curl
          jq
        ]
      }"

      NEW_VERSION=$(
        curl --silent https://api.github.com/repos/nubjs/nub/releases/latest \
          | jq -r '.tag_name | ltrimstr("v")'
      )

      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
        echo "The new version same as the old version."

        exit 0
      fi

      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "nub" "$NEW_VERSION" \
          --ignore-same-version \
          --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Fast TypeScript-first runtime and pnpm-compatible package manager for Node";
    homepage = "https://nubjs.com";
    downloadPage = "https://github.com/nubjs/nub/releases";
    license = lib.licenses.mit;
    mainProgram = "nub";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    maintainers = with lib.maintainers; [ euphemism ];
  };
})
