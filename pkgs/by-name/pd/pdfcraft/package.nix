{
  lib,
  stdenv,
  rustPlatform,
  versionCheckHook,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  craft-fonts,
  xcbuild,
  rcodesign,

  nix-update-script,
}:

let
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    wayland
    vulkan-loader
    libxrandr
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pdfcraft";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "pdfcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2X2ixtr7mxHRpfhcGghKUO7ib0SFBruBmQPIlTFZ8Ds=";
  };

  cargoHash = "sha256-sjnRF9WVDRPrgEgwZEyVIEk3qq3Erkv9cBtlkgb52lc=";

  # [[patch.unused]] egui fork entries in Cargo.toml break cargo --offline in the sandbox.
  postPatch = ''
    sed -i -E '/^(egui_demo_lib|egui_inspection|egui_system_font_provider) = /d' Cargo.toml

    # Until https://github.com/storytold/craft-libs/issues/492: startup update UI does not work on NixOS.
    substituteInPlace apps/pdfcraft/src/main.rs \
      --replace-fail 'app.set_startup_update_check(true);' 'app.set_startup_update_check(false);'
  ''
  + lib.optionalString stdenv.hostPlatform.isx86_64 ''
        # rten-gemm uses AVX512-VNNI intrinsics that fail to compile with nixpkgs rustc.
        substituteInPlace "$cargoDepsCopy"/source-registry-0/rten-gemm-*/src/i8dot.rs \
          --replace-fail \
          '            if let Some(isa) = x86_64::Avx512VnniIsa::new() {
                    return unsafe { dispatch_avx512_vnni(isa, self) };
                }
    ' \
          ""
  '';

  __structuredAttrs = true;

  env = {
    CRAFT_FONTS_DIR = craft-fonts;
    CRAFT_FONTS_REQUIRED = "1";
  };

  cargoBuildFlags = [
    "--package=pdfcraft"
    "--package=pdfcraft-cli"
  ];

  nativeBuildInputs = [
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    rcodesign
  ];

  # aws-lc-sys >= 0.42 is forced onto the system library by the nixpkgs crate
  # override (AWS_LC_SYS_USE_SYSTEM=1) and does not find it unless it is here.
  buildInputs = [ aws-lc ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 packaging/linux/ai.storyteller.pdfcraft.desktop \
        $out/share/applications/ai.storyteller.pdfcraft.desktop
      mkdir -p $out/share/icons
      cp -R assets/app-icon/hicolor $out/share/icons/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      APP="$out/Applications/PdfCraft.app"

      mkdir -p $APP/Contents/{MacOS,Resources}

      ln -s $out/bin/pdfcraft $out/Applications/PdfCraft.app/Contents/MacOS/PdfCraft
      # ln -s $out/bin/pdfcraft-cli $out/Applications/PdfCraft.app/Contents/MacOS/pdfcraft-cli

      cp $NIX_BUILD_TOP/source/assets/app-icon/pdfcraft.icns $APP/Contents/Resources/PdfCraft.icns
      cp $NIX_BUILD_TOP/source/NOTICE $NIX_BUILD_TOP/source/packaging/macos/Credits.rtf $APP/Contents/Resources/

      sed -e "s/@VERSION@/${finalAttrs.version}/g" -e "s/@SHORT_VERSION@/${finalAttrs.version}/g" \
        -e "s/@BUILD_SHA@/unknown}/g" \
        "$NIX_BUILD_TOP/source/packaging/macos/Info.plist.in" >"$APP/Contents/Info.plist"
      plutil -lint "$APP/Contents/Info.plist"

      printf 'APPL????' >"$APP/Contents/PkgInfo"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP/Contents/MacOS/PdfCraft"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP"
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/pdfcraft
  '';

  # The `pdfcraft` crate runs live GPU tests; software rendering in CI is too slow.
  cargoTestFlags = [
    "--package=pdfcraft-cli"
  ];

  # pdfcraft-cli `ui_control` tests bind loopback TCP (sandbox blocks without this on Darwin).
  __darwinAllowLocalNetworking = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source PDF workbench for reading, organizing, and securing documents";
    homepage = "https://github.com/storytold/pdfcraft";
    changelog = "https://github.com/storytold/pdfcraft/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      AND [
        (OR [
          mit
          asl20
        ])
        ofl
      ];
    maintainers = with lib.maintainers; [ cleboost ];
    mainProgram = "pdfcraft";
  };
})
