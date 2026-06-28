{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  nix-update-script,
  rustPlatform,
  cargo-tauri,
  desktop-file-utils,
  glib-networking,
  libayatana-appindicator,
  nodejs,
  npmHooks,
  openssl,
  pdfium-binaries,
  pkg-config,
  protobuf,
  webkitgtk_4_1,
  wrapGAppsHook4,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "llm-wiki";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "nashsu";
    repo = "llm_wiki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mXn2CNXYkOMJxVPlc4H/KRfM6wvEdC3GMaaZRr7U0LI=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;
  cargoHash = "sha256-Bg+h1+NlUa2vJ0+g+ypFGhXkxyWB2mMqT82MYUOEmGo=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-YGBpneK/qIMSvL+gIhBUSmolVm3S+h4E90e/s2ZEwks=";
  };

  __structuredAttrs = true;

  postPatch =
    # Like chiri/package.nix, patch libappindicator-sys to load Nix's appindicator library.
    lib.optionalString stdenv.hostPlatform.isLinux ''
      for libappindicatorRs in $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs; do
        if [[ -f "$libappindicatorRs" ]]; then
          substituteInPlace "$libappindicatorRs" \
            --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
        fi
      done
    ''
    + ''
      # Upstream ships bundled PDFium binaries and swaps the Linux ARM64
      # library in CI. Use nixpkgs' pdfium-binaries instead, and keep the
      # paths the same as what llm-wiki expects/does in CI.
      # llm-wiki CI swapping pdfium can be seen here:
      # https://github.com/nashsu/llm_wiki/blob/ea16fda6ea80fca68a3552f326d49870fb65dea5/.github/workflows/build.yml#L59-L72
      rm -f \
        src-tauri/pdfium/libpdfium.so \
        src-tauri/pdfium/libpdfium-arm64.so \
        src-tauri/pdfium/libpdfium.dylib \
        src-tauri/pdfium/pdfium.dll
      install -m644 ${pdfium-binaries}/lib/libpdfium${stdenv.hostPlatform.extensions.sharedLibrary} \
        src-tauri/pdfium/libpdfium${stdenv.hostPlatform.extensions.sharedLibrary}
    '';

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
    protobuf
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    webkitgtk_4_1
  ];

  env.OPENSSL_NO_VENDOR = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop application for building and maintaining structured wikis from documents with LLMs";
    homepage = "https://github.com/nashsu/llm_wiki";
    changelog = "https://github.com/nashsu/llm_wiki/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.gpl3Only ] ++ lib.toList pdfium-binaries.meta.license;
    maintainers = with lib.maintainers; [ futile ];
    mainProgram = "llm-wiki";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # Package uses binary PDFium libraries.
      binaryNativeCode
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      # Upstream publishes x86_64 Windows binaries, but cargo-tauri.hook does
      # not support Windows.
    ];
  };
})
