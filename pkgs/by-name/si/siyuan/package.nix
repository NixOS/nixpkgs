{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  buildGoModule,
  replaceVars,
  pandoc,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpmBuildHook,
  electron_44,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  xdg-utils,
  zip,
  python3,
  onnxruntime,
  darwin,
}:

let
  inherit (stdenv.hostPlatform) isLinux isDarwin system;

  # app/package.json pins pnpm 12 and Electron 44; nixpkgs' default Electron 43
  # breaks pasting.
  pnpm = pnpm_12;
  electron = electron_44;

  platformIds = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linux-arm64";
    "aarch64-darwin" = "darwin-arm64";
  };

  platformId = platformIds.${system} or (throw "Unsupported platform: ${system}");

  # electron-builder looks for a pandoc archive with this name; its contents
  # are a placeholder replaced in installPhase.
  pandocArchives = {
    "linux" = "pandoc-linux-amd64.zip";
    "linux-arm64" = "pandoc-linux-arm64.zip";
    "darwin-arm64" = "pandoc-darwin-arm64.zip";
  };

  pandocArchive = pandocArchives.${platformId};

  # Upstream's beforePack hook downloads the OCR models, which the sandbox
  # cannot do. This is a copy of upstream's scripts/ocr-assets.json, refreshed
  # by update.sh.
  ocrManifest = builtins.fromJSON (builtins.readFile ./ocr-assets.json);

  # Where prepare-ocr.py expects the runtime library, per platform.
  ocrTarget =
    {
      "linux" = "linux-amd64";
      "linux-arm64" = "linux-arm64";
      "darwin-arm64" = "darwin-arm64";
    }
    .${platformId};

  # Model data only (onnx weights and yml); nothing here is executed.
  ocrModels = map (entry: {
    path = entry.path;
    file = fetchurl {
      url = entry.url;
      sha256 = entry.sha256;
    };
  }) ocrManifest.models;

  # Place the models where prepare-ocr.py checks them against the manifest.
  ocrModelCopies = lib.concatMapStringsSep "\n" (m: ''
    mkdir -p "$(dirname "stage/ocr/models/${m.path}")"
    cp -f ${m.file} "stage/ocr/models/${m.path}"
  '') ocrModels;

  dedupePandoc = resourcesDir: ''
    rm -rf ${resourcesDir}/pandoc
    mkdir -p ${resourcesDir}/pandoc/bin
    ln -s ${lib.getExe pandoc} ${resourcesDir}/pandoc/bin/pandoc
  '';

  # The kernel loads onnxruntime through OrtGetApiBase, whose C API is
  # backwards compatible, so the Nix library can replace the bundled one.
  dedupeOnnxruntime = resourcesDir: ''
    ocrRuntimeDir=${resourcesDir}/stage/ocr/runtime/${ocrTarget}
    mkdir -p "$ocrRuntimeDir"
    ortLib=${lib.getLib onnxruntime}/lib/libonnxruntime.${if isDarwin then "dylib" else "so"}
    test -e "$ortLib" || {
      echo "onnxruntime library missing: $ortLib"
      exit 1
    }
    ln -sfn "$ortLib" "$ocrRuntimeDir/libonnxruntime.${if isDarwin then "dylib" else "so"}"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "siyuan";
  version = "3.8.12";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pEvpq/kohY94SDGw8oVAXoHDPxnyaPcV1M644psiY/o=";
  };

  kernel = buildGoModule {
    name = "${finalAttrs.pname}-${finalAttrs.version}-kernel";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/kernel";
    vendorHash = "sha256-KNeqEDMcyLJBQpVwtvTI1B32/BaLpMPyRKdCvmcbuZ8=";

    patches = [
      (replaceVars ./set-pandoc-path.patch {
        pandoc_path = lib.getExe pandoc;
      })
    ];

    # Set flags and tags as per upstream's Dockerfile
    ldflags = [
      "-s"
      "-X 'github.com/siyuan-note/siyuan/kernel/util.Mode=prod'"
    ];
    tags = [
      "fts5"
      "sqlcipher"
    ]
    ++ lib.optionals isLinux [
      # The Nix kernel is dynamically linked, so it can load onnxruntime.
      "ocr_inprocess"
    ];

    # `./...` also builds apigen and harmony, ~180 MiB of unused binaries.
    subPackages = [ "." ];

    env.CGO_ENABLED = "1";

    # Many upstream tests need the system MIME table, fonts or model.Conf;
    # run them as passthru.tests.kernel instead.
    doCheck = false;
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    pnpmBuildHook
    zip
    python3
  ]
  ++ lib.optionals isLinux [
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-GjJmx1uyhTpY5DmxGh9mMNLsXUsZpH68074CB6nIEF8=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # afterPack builds an optional Quick Look extension with swiftc. The package
  # does not ship it, so skip the Darwin-only Swift build.
  postPatch = lib.optionalString isDarwin ''
    substituteInPlace scripts/quicklook.js \
      --replace-fail \
        'const compileQuickLook = async (appPath, version, run = execFileSync) => {' \
        'const compileQuickLook = async (appPath, version, run = execFileSync) => { return; // not shipped'
  '';

  postConfigure = ''
    # Upstream's prebuilt archives are untrusted and get replaced by a symlink.
    rm -f pandoc/pandoc-*.zip
    mkdir -p pandoc/bin
    printf 'placeholder: replaced by a store symlink in installPhase\n' > pandoc/bin/pandoc
    (
      cd pandoc
      zip -qr ${pandocArchive} bin/pandoc
    )
    rm -rf pandoc/bin

    # Where electron-builder looks for the kernel.
    mkdir kernel-${platformId}
    ln -s ${finalAttrs.kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel

    # The app build recreates electron-dist, so keep the runtime elsewhere.
    cp -r ${electron.dist} electron-runtime
    chmod -R u+w electron-runtime

    # prepare-ocr.py locates its manifest and staging directory relative to
    # the repository root, and expects a writable tree. Mirror the parts it
    # needs, run it here, and make the hook a no-op.
    mkdir -p ocr-layout/scripts
    cp ${finalAttrs.src}/scripts/prepare-ocr.py ocr-layout/scripts/
    cp ${./ocr-assets.json} ocr-layout/scripts/ocr-assets.json
    ln -s "$PWD" ocr-layout/app

    ${ocrModelCopies}
    python3 ocr-layout/scripts/prepare-ocr.py

    cat > scripts/beforePack.js <<'OCR_EOF'
    // OCR resources were staged in postConfigure.
    module.exports = async function beforePack() {};
    OCR_EOF
  '';

  postBuild = ''
    electronBuilderArgs=(
      --dir
      --config electron-builder-${platformId}.yml
      -c.electronDist=electron-runtime
      -c.electronVersion=${electron.version}
      -c.mac.identity=null
    )

    npm exec electron-builder -- "''${electronBuilderArgs[@]}"
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString isDarwin ''
    mkdir -p $out/Applications $out/bin

    cp -R build/mac*/*.app $out/Applications/SiYuan.app

    ${dedupePandoc "$out/Applications/SiYuan.app/Contents/Resources"}
    ${dedupeOnnxruntime "$out/Applications/SiYuan.app/Contents/Resources"}

    cat > $out/bin/siyuan << EOF
    #!${stdenv.shell}
    exec open -na "$out/Applications/SiYuan.app" --args "\$@"
    EOF
    chmod +x $out/bin/siyuan
  ''
  + lib.optionalString isLinux ''
    mkdir -p $out/share/siyuan

    cp -r build/*-unpacked/{locales,resources{,.pak}} $out/share/siyuan

    ${dedupePandoc "$out/share/siyuan/resources"}
    ${dedupeOnnxruntime "$out/share/siyuan/resources"}

    # Relative path arguments resolve against process.cwd().
    makeWrapper ${lib.getExe electron} $out/bin/siyuan \
        --add-flags $out/share/siyuan/resources/app \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
        --inherit-argv0

    install -Dm644 src/assets/icon.svg $out/share/icons/hicolor/scalable/apps/siyuan.svg
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optional isLinux (makeDesktopItem {
    name = "siyuan";
    desktopName = "SiYuan";
    comment = "Refactor your thinking";
    icon = "siyuan";
    exec = "siyuan %U";
    categories = [ "Utility" ];
  });

  passthru = {
    kernel = finalAttrs.kernel;

    # Updates the version, hashes and ocr-assets.json; see update.sh.
    updateScript = ./update.sh;

    # The kernel tests do not pass in the sandbox; keep them runnable
    # separately.
    tests.kernel = finalAttrs.kernel.overrideAttrs {
      pname = "${finalAttrs.pname}-kernel-test";
      doCheck = true;
      checkPhase = ''
        runHook preCheck
        go test -vet=off -tags=fts5,sqlcipher${lib.optionalString isLinux ",ocr_inprocess"} ./...
        runHook postCheck
      '';
      installPhase = "touch $out";
    };
  };

  meta = {
    description = "Privacy-first personal knowledge management system that supports complete offline usage, as well as end-to-end encrypted data sync";
    homepage = "https://b3log.org/siyuan/";
    license = lib.licenses.agpl3Plus;
    mainProgram = "siyuan";
    maintainers = with lib.maintainers; [
      tomasajt
      ltrump
      myul
    ];
    platforms = lib.attrNames platformIds;
  };
})
