{
  stdenv,
  lib,
  pandoc,
  typst,
  esbuild,
  deno,
  fetchurl,
  dart-sass,
  installShellFiles,
  rWrapper,
  rPackages,
  extraRPackages ? [ ],
  makeWrapper,
  runCommand,
  python3,
  extraPythonPackages ? ps: [ ],
  sysctl,
  which,
  autoPatchelfHook,
  bashNonInteractive,
  coreutils,
  versionCheckHook,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
}:

let
  rWithPackages = rWrapper.override {
    packages = [
      rPackages.rmarkdown
    ]
    ++ extraRPackages;
  };

  pythonWithPackages = python3.withPackages (
    ps:
    with ps;
    [
      jupyter
      ipython
    ]
    ++ (extraPythonPackages ps)
  );

  # bin/quarto resolves every bundled tool through bin/tools/$ARCH_DIR, which it
  # derives from uname and can only ever be x86_64 or aarch64
  archDir = stdenv.hostPlatform.parsed.cpu.name;
  denoDomExt = if stdenv.hostPlatform.isDarwin then "dylib" else "so";
  denoDomPlugin = "libplugin.${denoDomExt}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "quarto";
  version = "1.10.18";

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # the macOS tarball unpacks flat instead of into a versioned directory
  sourceRoot = if stdenv.hostPlatform.isDarwin then "." else "quarto-${finalAttrs.version}";

  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = [
    # bin/quarto is a bash script; under strictDeps patchShebangs only resolves
    # its interpreter from the host dependencies
    bashNonInteractive
  ]
  # libgcc_s.so.1 for the retained typst-gather and deno_dom binaries
  ++ lib.optionals stdenv.hostPlatform.isLinux [ (stdenv.cc.cc.libgcc or null) ];

  # Patches quarto to use older API's from pandoc 3.7
  # Quarto upstream is built against, and expects pandoc 3.8+ .
  patches = lib.optionals (lib.versionOlder pandoc.version "3.8") [
    ./older-pandoc-compat.patch
  ];

  dontStrip = true;

  preFixup = ''
    wrapProgram $out/bin/quarto \
      --set-default QUARTO_DENO ${lib.getExe deno} \
      --set-default QUARTO_PANDOC ${lib.getExe pandoc} \
      --set-default QUARTO_ESBUILD ${lib.getExe esbuild} \
      --set-default QUARTO_DART_SASS ${lib.getExe dart-sass} \
      --set-default QUARTO_TYPST ${lib.getExe typst} \
      --set-default QUARTO_DENO_DOM $out/bin/tools/${archDir}/deno_dom/${denoDomPlugin} \
      --suffix PATH : ${
        lib.makeBinPath [
          coreutils
          which
        ]
      } \
      ${lib.optionalString (rWrapper != null) "--set-default QUARTO_R ${rWithPackages}/bin/R"} \
      ${
        lib.optionalString (python3 != null) "--set-default QUARTO_PYTHON ${pythonWithPackages}/bin/python3"
      } \
      ${lib.optionalString (
        rWrapper != null
      ) "--set-default RETICULATE_PYTHON ${pythonWithPackages.interpreter}"}
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # the macOS asset bundles a complete tool tree for every architecture,
    # alongside AppleDouble metadata files
    find bin/tools -mindepth 1 -maxdepth 1 -type d ! -name ${archDir} -exec rm -r {} +
    find . -name '._*' -delete
  ''
  + ''
    tools=bin/tools/${archDir}
    if [ ! -d "$tools" ]; then
      echo "upstream no longer ships $tools, which is where quarto looks up its tools" >&2
      exit 1
    fi

    # swap the vendored tools for the nixpkgs builds. typst-gather and deno_dom
    # have no nixpkgs equivalent and are kept: dropping the whole directory
    # broke `quarto call typst-gather` and the DENO_DOM_PLUGIN export.
    rm -r "$tools"/deno "$tools"/pandoc "$tools"/typst "$tools"/esbuild "$tools"/dart-sass

    ln -s ${lib.getExe deno} "$tools"/deno
    ln -s ${lib.getExe pandoc} "$tools"/pandoc
    ln -s ${lib.getExe typst} "$tools"/typst
    ln -s ${lib.getExe esbuild} "$tools"/esbuild
    mkdir "$tools"/dart-sass
    ln -s ${lib.getExe dart-sass} "$tools"/dart-sass/sass

    # the linux-arm64 asset names the plugin libplugin-linux-aarch64.so, while
    # bin/quarto and QUARTO_DENO_DOM only ever point at the unsuffixed name; a
    # dlopen miss is swallowed and silently downgrades quarto to the wasm parser
    if [ ! -e "$tools"/deno_dom/${denoDomPlugin} ]; then
      mv "$tools"/deno_dom/libplugin*.${denoDomExt} "$tools"/deno_dom/${denoDomPlugin}
    fi

    # pre-1.4 location, still probed by the VS Code extension
    ln -s ${archDir}/pandoc bin/tools/pandoc

    # share/man also holds the qmd the page is generated from, which
    # compressManPages would gzip in place for mandb to trip over
    installManPage --name quarto.1 share/man/quarto-man.man
    rm -r share/man

    mv bin/* $out/bin
    mv share/* $out/share

    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${finalAttrs.version}/quarto-${finalAttrs.version}-linux-amd64.tar.gz";
        hash = "sha256-r60HG1vSLALy0wBpV0MYnTZQ4FN6Uwc+ZUtjDP8rDHM=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${finalAttrs.version}/quarto-${finalAttrs.version}-linux-arm64.tar.gz";
        hash = "sha256-9qB99o4lMwtd809l099mvKYFrM47gwxZOljpGITUz2w=";
      };
      # the macOS asset is a universal binary carrying both architectures
      aarch64-darwin = fetchurl {
        url = "https://github.com/quarto-dev/quarto-cli/releases/download/v${finalAttrs.version}/quarto-${finalAttrs.version}-macos.tar.gz";
        hash = "sha256-3danGp4ESKsV+2VbxYnhHLZYmiSOw1zNf39EE3UxaI4=";
      };
    };

    tests = {
      quarto-check =
        runCommand "quarto-check"
          {
            nativeBuildInputs = [ which ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ sysctl ];
          }
          ''
            export HOME="$(mktemp -d)"
            ${lib.getExe finalAttrs.finalPackage} check
            touch $out
          '';
    };

    updateScript = writeShellScript "update-quarto" ''
      set -o errexit -o pipefail
      export PATH="${
        lib.makeBinPath [
          curl
          jq
          common-updater-scripts
        ]
      }"
      NEW_VERSION=$(curl --fail --silent --show-error --location https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | jq '.tag_name | ltrimstr("v")' --raw-output)
      # a truncated response still leaves jq at exit 0, and an empty version
      # would reach update-source-version
      if [[ -z "$NEW_VERSION" || "$NEW_VERSION" = "null" ]]; then
          echo "Could not read the latest release tag from the GitHub API." >&2
          exit 1
      fi
      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi
      for platform in ${lib.escapeShellArgs finalAttrs.meta.platforms}; do
        update-source-version "''${UPDATE_NIX_ATTR_PATH:-quarto}" "$NEW_VERSION" --ignore-same-version --source-key="sources.$platform"
      done
    '';
  };

  meta = {
    description = "Open-source scientific and technical publishing system built on Pandoc";
    mainProgram = "quarto";
    longDescription = ''
      Quarto is an open-source scientific and technical publishing system built on Pandoc.
      Quarto documents are authored using markdown, an easy to write plain text format.
    '';
    homepage = "https://quarto.org/";
    changelog = "https://github.com/quarto-dev/quarto-cli/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mrtarantoga
    ];
    platforms = builtins.attrNames finalAttrs.passthru.sources;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      binaryBytecode
    ];
  };
})
