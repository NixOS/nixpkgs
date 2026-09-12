{
  apple-sdk_14,
  appimageTools,
  cargo-tauri,
  cmake,
  fetchFromGitHub,
  fetchPnpmDeps,
  fetchurl,
  gitMinimal,
  lib,
  nodejs_24,
  perl,
  pnpm_11,
  pnpmConfigHook,
  rcodesign,
  rustPlatform,
  stdenv,
  writeText,
}:

let
  pname = "buzz-desktop";
  version = "0.5.22";

  # Linux uses upstream's AppImage, which carries their release-only mesh-llm
  # feature. Building that from source needs the Mesh git dependencies and a
  # separately pinned sherpa-onnx archive, so the Darwin source build ships
  # Cargo's default features instead.
  linuxSrc = fetchurl {
    url = "https://github.com/block/buzz/releases/download/desktop-v${version}/Buzz_${version}_amd64.AppImage";
    hash = "sha256-RxIQAaHJ7i+8MYZyMm7oor2T2RR4XBZaD8AJR+NJNbE=";
  };

  darwinSrc = fetchFromGitHub {
    owner = "block";
    repo = "buzz";
    tag = "desktop-v${version}";
    hash = "sha256-p4WLDBwiNiw1qlVo12Sz5js/r/6A3SiHBNCx8V9WlSs=";
  };

  # The desktop crate and the sidecars use separate Cargo workspaces. Reuse
  # the fixed-output release sidecars instead of vendoring and building both.
  darwinSidecars = fetchurl {
    url = "https://github.com/block/buzz/releases/download/desktop-v${version}/Buzz_${version}_aarch64.app.tar.gz";
    hash = "sha256-vyO1F9YRae52pisNLgp4+s2bp3WnkimN9K4lKjMd4eA=";
  };

  sidecars = [
    "buzz"
    "buzz-acp"
    "buzz-agent"
    "buzz-backend-kubernetes"
    "buzz-dev-mcp"
    "git-credential-nostr"
  ];

  sidecarEntitlementFlags = lib.concatMapStringsSep " " (
    sidecar: "--entitlements-xml-file Contents/MacOS/${sidecar}:${emptyEntitlements}"
  ) sidecars;

  emptyEntitlements = writeText "buzz-empty-entitlements.plist" (
    lib.generators.toPlist { escape = true; } { }
  );

  # The hardened runtime enforces library validation, which maps a dylib only
  # when it is a platform binary or carries the process' team identifier. The
  # main binary links Nixpkgs' libiconv, and an ad-hoc signature has no team,
  # so without this exception dyld aborts before main. The sidecars link
  # nothing outside the system libraries, so they do not need it.
  mainEntitlements = writeText "buzz-main-entitlements.plist" (
    lib.generators.toPlist { escape = true; } {
      "com.apple.security.cs.disable-library-validation" = true;
      "com.apple.security.device.audio-input" = true;
      "com.apple.security.device.camera" = true;
    }
  );

  commonMeta = {
    description = "Workspace where humans and AI agents build together";
    homepage = "https://buzz.xyz";
    changelog = "https://github.com/block/buzz/releases/tag/desktop-v${version}";
    license = lib.licenses.asl20;
    mainProgram = "buzz-desktop";
    maintainers = [ lib.maintainers.sebfried ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };

  linuxContents = appimageTools.extract {
    inherit pname version;
    src = linuxSrc;

    postExtract = ''
      # Use the FHS environment's OpenSSL for both Buzz and GStreamer. Keeping
      # the older bundled copy makes Nixpkgs' GStreamer plugins fail to load.
      rm $out/usr/lib/lib{crypto,ssl}.so.3

      # Tauri treats APPIMAGE as permission to self-update. Hide it from the
      # immutable Nix installation while leaving the wrapped app unchanged.
      #
      # buildFHSEnv exports GST_PLUGIN_SYSTEM_PATH_1_0, linuxdeploy's AppRun
      # then overwrites it with the bundle's own directory, and upstream's
      # shim unsets any value pointing into the bundle. Restore the FHS path
      # afterwards, otherwise WebKit finds no plugins and renders nothing.
      substituteInPlace $out/usr/bin/buzz-desktop \
        --replace-fail \
          'exec -a "buzz-desktop" "$here/buzz-desktop.bin" "$@"' \
          'unset APPIMAGE; export GST_PLUGIN_SYSTEM_PATH_1_0=/usr/lib/gstreamer-1.0; exec -a "buzz-desktop" "$here/buzz-desktop.bin" "$@"'
    '';
  };

  linuxPackage = appimageTools.wrapAppImage {
    inherit pname version;
    src = linuxContents;

    extraPkgs =
      pkgs: with pkgs; [
        elfutils.out
        ffmpeg
        git
        gst_all_1.gst-plugins-good
        gst_all_1.gst-plugins-bad
        gst_all_1.gst-libav
        libayatana-appindicator
        zstd.out
      ];

    extraInstallCommands = ''
      install -Dm444 ${linuxContents}/usr/share/applications/Buzz.desktop \
        $out/share/applications/buzz-desktop.desktop
      substituteInPlace $out/share/applications/buzz-desktop.desktop \
        --replace-fail "Exec=buzz-desktop" "Exec=buzz-desktop %u" \
        --replace-fail "Categories=" "Categories=Network;Chat;"
      cp -r ${linuxContents}/usr/share/icons $out/share/
    '';

    meta = commonMeta // {
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };

  darwinPackage = rustPlatform.buildRustPackage (finalAttrs: {
    inherit pname version;
    src = darwinSrc;
    # The upstream test suite starts loopback servers on 127.0.0.1.
    __darwinAllowLocalNetworking = true;
    # Preserve the imported sidecars; strip only the source-built main binary.
    dontStrip = true;

    cargoRoot = "desktop/src-tauri";
    buildAndTestSubdir = finalAttrs.cargoRoot;
    cargoHash = "sha256-3OJbkr3GM2lQY9nHKdrg5b1lct32KZJ0+wjCdupoiCw=";

    patches = [
      # env!("CARGO_MANIFEST_DIR") survives --remap-path-prefix, so release
      # builds would embed and search the temporary build directory.
      ./dev-only-sidecar-discovery.patch
      # Nixpkgs runs the tests in the release profile, where the two migration
      # helpers these tests call are compiled out. Not yet sent upstream.
      ./test-cfg-migration-helpers.patch
    ];

    pnpmDeps = fetchPnpmDeps {
      inherit pname version;
      src = darwinSrc;
      pnpm = pnpm_11;
      fetcherVersion = 4;
      hash = "sha256-qxtgbCeivfpAQg2+JOUGCQo7agf0GAARvLle89jFzu4=";
    };

    nativeBuildInputs = [
      cargo-tauri.hook
      cmake
      nodejs_24
      pnpm_11
      pnpmConfigHook
      rcodesign
    ];

    buildInputs = [ apple-sdk_14 ];

    nativeCheckInputs = [
      gitMinimal
      perl
    ];

    postPatch = ''
      sidecarSource=$(mktemp -d)
      tar -xzf ${darwinSidecars} -C "$sidecarSource"
      for sidecar in ${lib.escapeShellArgs sidecars}; do
        install -Dm755 \
          "$sidecarSource/Buzz.app/Contents/MacOS/$sidecar" \
          "desktop/src-tauri/binaries/$sidecar-${stdenv.hostPlatform.rust.rustcTarget}"
      done

      # Tauri otherwise targets macOS 10.13 (11.0 on aarch64), while the
      # Nixpkgs Rust standard library is built for darwinMinVersion.
      substituteInPlace desktop/src-tauri/tauri.conf.json \
        --replace-fail '    "macOS": {' \
          $'    "macOS": {\n      "minimumSystemVersion": "${stdenv.hostPlatform.darwinMinVersion}",'
    '';

    # Panic messages would otherwise carry the temporary build directory, which
    # differs between builds. disallowedReferences covers the source itself.
    preBuild = ''
      export NIX_RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${NIX_RUSTFLAGS:-}"
      export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build -fdebug-prefix-map=$NIX_BUILD_TOP=/build -fmacro-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
    '';

    tauriBuildFlags = [ "--no-sign" ];

    postInstall = ''
      mkdir -p "$out/bin"
      ln -s ../Applications/Buzz.app/Contents/MacOS/buzz-desktop \
        "$out/bin/buzz-desktop"
    '';

    # Runs after the standard fixups, so the strip below is the last change to
    # the binaries before the bundle is sealed. rcodesign carries a binary's
    # previous entitlements over, so the sidecars need explicit empty ones:
    # upstream signs all six with camera, microphone, and library-validation
    # exceptions. Only the main binary links a Nix-store dylib, so only it
    # carries the library-validation exception; the helpers keep the hardened
    # runtime but no entitlements at all.
    postFixup = ''
      main="$out/Applications/Buzz.app/Contents/MacOS/buzz-desktop"
      strip -S "$main"

      rcodesign sign \
        --code-signature-flags Contents/MacOS/buzz-desktop:runtime \
        --entitlements-xml-file Contents/MacOS/buzz-desktop:${mainEntitlements} \
        ${sidecarEntitlementFlags} \
        "$out/Applications/Buzz.app"
    '';

    disallowedReferences = [ darwinSrc ];

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck

      app="$out/Applications/Buzz.app"
      main="$app/Contents/MacOS/buzz-desktop"
      test -x "$main"

      # build.rs only sets the buzz_updater_enabled cfg when BUZZ_UPDATER_ENDPOINT
      # and BUZZ_UPDATER_PUBLIC_KEY are both non-empty, and lib.rs registers
      # Tauri's updater plugin only under that cfg, so a Nix build never gets
      # one. Its HTTP user agent is the marker: upstream's own release binary
      # contains it, this one must not.
      strings "$main" > buzz-desktop.strings
      if grep -Fq 'tauri-plugin-updater/' buzz-desktop.strings; then
        echo "Updater plugin is linked into the application" >&2
        exit 1
      fi

      # Only the source-built binary follows darwinMinVersion; the imported
      # sidecars keep upstream's own, lower minimum.
      otool -l "$main" > buzz-desktop-build-version
      grep -Fq 'minos ${stdenv.hostPlatform.darwinMinVersion}' buzz-desktop-build-version
      grep -A1 LSMinimumSystemVersion "$app/Contents/Info.plist" \
        | grep -Fq '<string>${stdenv.hostPlatform.darwinMinVersion}</string>'

      rcodesign print-signature-info "$main" > buzz-desktop-signature
      grep -Fq 'flags: CodeSignatureFlags(ADHOC | RUNTIME)' buzz-desktop-signature
      grep -Fq '<key>com.apple.security.cs.disable-library-validation</key>' buzz-desktop-signature
      grep -Fq '<key>com.apple.security.device.audio-input</key>' buzz-desktop-signature
      grep -Fq '<key>com.apple.security.device.camera</key>' buzz-desktop-signature

      for sidecar in ${lib.escapeShellArgs sidecars}; do
        test -x "$app/Contents/MacOS/$sidecar"
        rcodesign print-signature-info "$app/Contents/MacOS/$sidecar" > "$sidecar-signature"
        if grep -Fq 'com.apple.security' "$sidecar-signature"; then
          echo "$sidecar kept upstream's entitlements" >&2
          exit 1
        fi
      done

      "$app/Contents/MacOS/buzz" --help >/dev/null

      runHook postInstallCheck
    '';

    meta = commonMeta // {
      sourceProvenance = with lib.sourceTypes; [
        binaryNativeCode
        fromSource
      ];
    };
  });
in
if stdenv.hostPlatform.isDarwin then darwinPackage else linuxPackage
