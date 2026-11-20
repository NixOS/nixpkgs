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

  # Upstream pins pnpm 12; fetcherVersion 5 keeps its JSONC links tree out of
  # fetchPnpmDeps' jq normalization on aarch64-darwin.
  pnpm = pnpm_12;

  # Upstream's app/package.json pins Electron 44; nixpkgs' default electron (43)
  # is known to break pasting, so follow upstream's major version.
  electron = electron_44;

  platformIds = {
    "x86_64-linux" = "linux";
    "aarch64-linux" = "linux-arm64";
    "aarch64-darwin" = "darwin-arm64";
  };

  platformId = platformIds.${system} or (throw "Unsupported platform: ${system}");

  # SiYuan's OCR only ever uses onnxruntime's default CPU execution provider
  # (kernel/ocr/runtime.c never appends another one), but nixpkgs enables the
  # OpenVINO provider on Linux by default. That drags OpenVINO, oneTBB and
  # level-zero (~200 MiB) into the closure for nothing.
  onnxruntimeMinimal = onnxruntime.override { openvinoSupport = false; };

  # The archive name electron-builder's extraResources expects per platform. It
  # is a placeholder: afterPack only checks that bin/pandoc is a non-empty
  # regular file, and the kernel uses the Nix pandoc via set-pandoc-path.patch.
  # installPhase swaps in a store symlink; shipping the real archive would put
  # 347 MiB into the client's store path.
  pandocArchives = {
    "linux" = "pandoc-linux-amd64.zip";
    "linux-arm64" = "pandoc-linux-arm64.zip";
    "darwin-arm64" = "pandoc-darwin-arm64.zip";
  };

  pandocArchive = pandocArchives.${platformId};

  # Built-in OCR: upstream's app/scripts/beforePack.js downloads the models —
  # and an onnxruntime blob — from the network, which the sandbox cannot do.
  # ./ocr-assets.json is a verbatim copy of upstream's scripts/ocr-assets.json,
  # so the models can be prefetched with fetchurl and the hook made a no-op.
  # update.sh refreshes it along with the version.
  ocrManifest = builtins.fromJSON (builtins.readFile ./ocr-assets.json);

  # Where upstream's prepare-ocr.py expects the runtime library, per platform.
  ocrTarget =
    {
      "linux" = "linux-amd64";
      "linux-arm64" = "linux-arm64";
      "darwin-arm64" = "darwin-arm64";
    }
    .${platformId};

  # Model data files only (onnx weights and yml): loaded, never executed.
  ocrModels = map (entry: {
    path = entry.path;
    file = fetchurl {
      url = entry.url;
      sha256 = entry.sha256;
    };
  }) ocrManifest.models;

  # Put every model where prepare-ocr.py's download() verifies it by hash.
  ocrModelCopies = lib.concatMapStringsSep "\n" (m: ''
    mkdir -p "$(dirname "stage/ocr/models/${m.path}")"
    cp -f ${m.file} "stage/ocr/models/${m.path}"
  '') ocrModels;

  dedupePandoc = resourcesDir: ''
    rm -rf ${resourcesDir}/pandoc
    mkdir -p ${resourcesDir}/pandoc/bin
    ln -s ${lib.getExe pandoc} ${resourcesDir}/pandoc/bin/pandoc
  '';

  # Same trick for OCR's onnxruntime: the kernel dlopens it from a fixed
  # relative path through OrtGetApiBase's C API, which is backwards compatible,
  # so nixpkgs' newer onnxruntime can serve a kernel built against the bundled
  # one.
  dedupeOnnxruntime = resourcesDir: ''
    ocrRuntimeDir=${resourcesDir}/stage/ocr/runtime/${ocrTarget}
    mkdir -p "$ocrRuntimeDir"
    ortLib=${lib.getLib onnxruntimeMinimal}/lib/libonnxruntime.${if isDarwin then "dylib" else "so"}
    test -e "$ortLib" || {
      echo "onnxruntime library missing: $ortLib"
      exit 1
    }
    ln -sfn "$ortLib" "$ocrRuntimeDir/libonnxruntime.${if isDarwin then "dylib" else "so"}"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "siyuan";
  version = "3.8.11";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8LN5K/QO7ys4nN0RdVPM4Pet19IYWY0U94x3Z/CJK7M=";
  };

  kernel = buildGoModule {
    name = "${finalAttrs.pname}-${finalAttrs.version}-kernel";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/kernel";
    vendorHash = "sha256-+EvqDvOvMo+juLgOl5WpTLEZqCGhleQU3GTspiCO+Yc=";

    patches = [
      (replaceVars ./set-pandoc-path.patch {
        pandoc_path = lib.getExe pandoc;
      })
      # Upstream commit 693a3395, paths made relative to kernel/, adds the
      # ocr_inprocess build tag so that a dynamically linked (CGO, glibc)
      # Linux kernel can load libonnxruntime.so in-process instead of spawning
      # the siyuan-ocr helper. It is in 3.9.0; drop this patch once the
      # package reaches that release.
      ./ocr-inprocess.patch
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
      # The kernel is linked against glibc, so it can load onnxruntime itself.
      "ocr_inprocess"
    ];

    # `go build ./...` also produces `apigen` (a 34 MiB code-generation tool)
    # and `harmony` (a 145 MiB HarmonyOS bundle). Nothing installs or runs
    # either one, but both end up in $out/bin and therefore in every closure
    # that references the kernel.
    subPackages = [ "." ];

    env.CGO_ENABLED = "1";

    # Tests are skipped here because many upstream tests make assumptions that
    # do not hold in the Nix sandbox (system MIME table, missing model.Conf
    # initialization, missing system fonts, our set-pandoc-path.patch, etc.).
    # They are run as a separate derivation via passthru.tests.kernel.
    doCheck = false;
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    # The webpack bundle lands in app/stage/build, which is gitignored upstream
    # and absent from the tarball, so every platform has to run the build;
    # otherwise the output ships without any JS bundle.
    pnpmBuildHook
    zip
    python3 # prepare-ocr.py is stdlib only
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
    hash = "sha256-8yo/siJNpaxTPZ0Fa20KyrODqw5mWItc86mUYxBFd/o=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    # Drop upstream's prebuilt archives (untrusted, and replaced by a store
    # symlink anyway) and ship the placeholder.
    rm -f pandoc/pandoc-*.zip
    mkdir -p pandoc/bin
    printf 'placeholder: replaced by a store symlink in installPhase\n' > pandoc/bin/pandoc
    (
      cd pandoc
      zip -qr ${pandocArchive} bin/pandoc
    )
    rm -rf pandoc/bin

    # link kernel into the correct starting place so that electron-builder can copy it to its final location
    mkdir kernel-${platformId}
    ln -s ${finalAttrs.kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel

    # build:electron deletes and recreates electron-dist for the app's own
    # compiled code, so keep the Electron runtime under a different name.
    cp -r ${electron.dist} electron-runtime
    chmod -R u+w electron-runtime
    # Upstream's beforePack hook runs ../scripts/prepare-ocr.py, which expects a
    # writable repo layout plus network access; mirror it here and make the hook
    # a no-op.
    mkdir -p ocr-layout/scripts
    cp -r ${finalAttrs.src}/scripts/. ocr-layout/scripts/
    ln -s "$PWD" ocr-layout/app
    # kernel has to be a real directory: the goModules FOD is a vendor tree
    # (modules.txt at its root) and the worker shares the kernel's modules.
    mkdir -p ocr-layout/kernel
    cp -r ${finalAttrs.src}/kernel/. ocr-layout/kernel/
    ln -s ${finalAttrs.kernel.goModules} ocr-layout/kernel/vendor

    ${ocrModelCopies}
    python3 ocr-layout/scripts/prepare-ocr.py

    cat > scripts/beforePack.js <<'OCR_EOF'
    // OCR resources were prefetched and placed by the nix build in
    // postConfigure; no-op so electron-builder does not redo any of it.
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

    # Keep the caller's cwd: relative path arguments resolve against
    # process.cwd().
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

    # Updates the version, the hashes and ocr-assets.json; see update.sh.
    updateScript = ./update.sh;

    # Upstream's kernel tests, exported so they stay runnable outside the
    # main build: nix-build -A siyuan.passthru.tests.kernel.
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
