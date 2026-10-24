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
  go_1_26,
  onnxruntime,
  darwin,
}:

let
  inherit (stdenv.hostPlatform) isLinux isDarwin system;

  # Upstream pins pnpm@12 in app/package.json. pnpm 12 materializes its global virtual
  # store under v11/links, where package JSONC files (tsconfig.json) break fetchPnpmDeps'
  # jq normalization on aarch64-darwin; fetcherVersion 5 stops archiving that tree.
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

  # The name electron-builder's extraResources expects for the current platform.
  # The archive we build is a placeholder: afterPack only checks that bin/pandoc
  # is a non-empty regular file, and the kernel uses the Nix pandoc directly via
  # set-pandoc-path.patch. installPhase replaces what gets unpacked with a store
  # symlink — shipping the real archive makes the client's own store path 347 MiB
  # instead of ~138 MiB.
  pandocArchives = {
    "linux" = "pandoc-linux-amd64.zip";
    "linux-arm64" = "pandoc-linux-arm64.zip";
    "darwin-arm64" = "pandoc-darwin-arm64.zip";
  };

  pandocArchive = pandocArchives.${platformId};

  # Built-in OCR (since v3.8.7): upstream's app/scripts/beforePack.js downloads
  # the models — and an onnxruntime blob — from the network, which the sandbox
  # cannot do. ./ocr-assets.json is a verbatim copy of upstream's
  # scripts/ocr-assets.json for this version (null once a version ships no OCR),
  # so the models can be prefetched with fetchurl and the hook made a no-op.
  # update.sh refreshes it along with the version; prepare-ocr.py fails the build
  # on a hash mismatch rather than silently skipping.
  ocrManifest = builtins.fromJSON (builtins.readFile ./ocr-assets.json);
  hasOCR = ocrManifest != null;

  # Where upstream's prepare-ocr.py expects the runtime library, per platform.
  ocrTarget =
    if hasOCR then
      {
        "linux" = "linux-amd64";
        "linux-arm64" = "linux-arm64";
        "darwin-arm64" = "darwin-arm64";
      }
      .${platformId}
    else
      null;

  # Model data files only (onnx weights and yml): loaded, never executed. The
  # prebuilt onnxruntime is not fetched — see dedupeOnnxruntime.
  ocrModels = lib.optionals hasOCR (
    map (entry: {
      path = entry.path;
      file = fetchurl {
        url = entry.url;
        sha256 = entry.sha256;
      };
    }) ocrManifest.models
  );

  # Put every model where prepare-ocr.py's download() verifies it: matching bytes
  # skip the download, mismatches fail right there.
  ocrModelCopies = lib.concatMapStringsSep "\n" (m: ''
    mkdir -p "$(dirname "stage/ocr/models/${m.path}")"
    cp -f ${m.file} "stage/ocr/models/${m.path}"
  '') ocrModels;

  # What afterPack extracted is our placeholder; the kernel uses the Nix pandoc.
  # Replace the directory with a single store symlink.
  dedupePandoc = resourcesDir: ''
    rm -rf ${resourcesDir}/pandoc
    mkdir -p ${resourcesDir}/pandoc/bin
    ln -s ${lib.getExe pandoc} ${resourcesDir}/pandoc/bin/pandoc
  '';

  # Same trick for OCR's onnxruntime: kernel (darwin, in-process) and worker
  # (linux, subprocess) dlopen it from a fixed relative path through
  # OrtGetApiBase's C API, which is backwards compatible, so nixpkgs' newer
  # onnxruntime can serve a worker built against an older one.
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
  version = "3.8.8";

  src = fetchFromGitHub {
    owner = "siyuan-note";
    repo = "siyuan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sa4p6shcbSYKXE7Zp7XilmqcAOp4kNKhoQNtl4zPpyE=";
  };

  kernel = buildGoModule {
    name = "${finalAttrs.pname}-${finalAttrs.version}-kernel";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/kernel";
    vendorHash = "sha256-pc1HFKp2TQeCBJHdc2lnQwlpxg8IJ9CKnPoYe+C6cKA=";

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
    ];

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
    # and absent from the tarball, so every platform has to run the build —
    # otherwise the output ships without any JS bundle. nixpkgs limited this to
    # linux, leaving the darwin build incomplete.
    pnpmBuildHook
    zip
  ]
  ++ lib.optionals isLinux [
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals isDarwin [
    darwin.autoSignDarwinBinariesHook
  ]
  ++ lib.optionals hasOCR [
    python3 # prepare-ocr.py is stdlib only
  ]
  ++ lib.optionals (hasOCR && isLinux) [
    # upstream builds a CGO ocr-worker on linux; gcc comes from stdenv
    go_1_26
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
    hash = "sha256-d4gxx9HebTdRBWuHBl8+lTzXTzjwl8G1R5UAndskPZ4=";
  };

  sourceRoot = "${finalAttrs.src.name}/app";

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    # Do not consume upstream's prebuilt pandoc archives: drop them and build a
    # placeholder zip under the name electron-builder's extraResources expects.
    # Nothing unaudited is unpacked or chmod +x'ed, and installPhase replaces
    # what afterPack extracted with a store symlink (dedupePandoc).
    rm -f pandoc/pandoc-*.zip
    mkdir -p pandoc/bin
    printf 'placeholder: replaced by a store symlink in installPhase\n' > pandoc/bin/pandoc
    (
      cd pandoc
      zip -qr ${pandocArchive} bin/pandoc
    )
    rm -rf pandoc/bin

    # link kernel into the correct starting place so that electron-builder can copy it to it's final location
    mkdir kernel-${platformId}
    ln -s ${finalAttrs.kernel}/bin/kernel kernel-${platformId}/SiYuan-Kernel

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
  ''
  + lib.optionalString hasOCR ''
    # ---- offline built-in OCR resources (since v3.8.7) ----
    # Upstream's beforePack hook runs ../scripts/prepare-ocr.py, which expects a
    # writable repo layout plus network access. Mirror that layout inside the
    # build directory, place the resources, do the hook's work here and make the
    # hook a no-op.
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

    # ocr-worker: the same command and output path as upstream's
    # prepare-ocr.py --build-worker, built offline in vendor mode.
    mkdir -p stage/ocr/runtime/${ocrTarget}
    ${lib.optionalString isLinux ''
      workerOut="$PWD/stage/ocr/runtime/${ocrTarget}/siyuan-ocr"
      (
        cd ocr-layout/kernel
        env CGO_ENABLED=1 GOFLAGS=-mod=vendor GOPROXY=off GOTOOLCHAIN=local \
          GOCACHE="$PWD/../../.gocache" \
          go build -trimpath -ldflags="-s -w" -o "$workerOut" ./ocr/cmd/ocr-worker
      )
    ''}

    # Resources are in place, so the hook has nothing left to do.
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
      -c.electronDist=electron-dist
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
    ${lib.optionalString hasOCR (dedupeOnnxruntime "$out/Applications/SiYuan.app/Contents/Resources")}

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
    ${lib.optionalString hasOCR (dedupeOnnxruntime "$out/share/siyuan/resources")}

    makeWrapper ${lib.getExe electron} $out/bin/siyuan \
        --chdir $out/share/siyuan/resources \
        --add-flags $out/share/siyuan/resources/app \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
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

    # Upstream kernel tests require model.Conf initialization, system fonts,
    # pandoc, and other assumptions that do not hold in the Nix sandbox during
    # the main build. Run them as a separate derivation so the package build
    # stays reliable while test results remain available via
    # nix-build -A siyuan.passthru.tests.kernel.
    tests.kernel = finalAttrs.kernel.overrideAttrs {
      pname = "${finalAttrs.pname}-kernel-test";
      doCheck = true;
      checkPhase = ''
        runHook preCheck
        go test -vet=off -tags=fts5,sqlcipher ./...
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
