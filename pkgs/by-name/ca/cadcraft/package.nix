{
  lib,
  stdenv,
  rustPlatform,
  rustc,
  fetchFromGitHub,
  pkg-config,
  patchelf,
  copyDesktopItems,
  makeDesktopItem,
  versionCheckHook,
  vulkan-loader,
  libxkbcommon,
  libx11,
  libxcb,
  libxcursor,
  libxi,
  libxrandr,
  wayland,
  dbus,
  nix-update-script,
  xcbuild,
  rcodesign,
}:

let
  # Loaded with dlopen by winit, wgpu and rfd (libdbus, for the file dialogs).
  runtimeDeps = [
    libxkbcommon
    libx11
    libxcb
    libxcursor
    libxi
    libxrandr
    wayland
    vulkan-loader
    dbus
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cadcraft";
  version = "0.6.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "storytold";
    repo = "cadcraft";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kyNUKQvYg9SLE7E7LD/qBMAcxueEPdP9XRz9+H82I1M=";
  };

  cargoHash = "sha256-ceBPm8kwhiqdpwgfFad/2lhiPVJeKrvbDLRAFYOofTI=";

  cargoBuildFlags = [
    "--package=cadcraft"
    "--package=cadcraft-cli"
  ];

  # The cadcraft-cli mcp_connect tests talk to a fake app over a loopback TCP socket.
  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [
    pkg-config
    patchelf
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    xcbuild
    rcodesign
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "ai.storyteller.cadcraft";
      desktopName = "CADCraft";
      genericName = "Computer-Aided Design";
      comment = "Draft, dimension and plot 2D drawings; open DXF and DWG files";
      exec = "cadcraft %F";
      tryExec = "cadcraft";
      icon = "ai.storyteller.cadcraft";
      terminal = false;
      startupNotify = true;
      startupWMClass = "ai.storyteller.cadcraft";
      categories = [
        "Graphics"
        "Engineering"
        "VectorGraphics"
      ];
      keywords = [
        "cad"
        "drafting"
        "dxf"
        "dwg"
        "drawing"
        "engineering"
        "architecture"
        "mechanical"
      ];
      mimeTypes = [
        "image/vnd.dxf"
        "image/vnd.dwg"
        "application/x-dxf"
        "application/acad"
      ];
    })
  ];

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 packaging/linux/ai.storyteller.cadcraft.mime.xml $out/share/mime/packages/ai.storyteller.cadcraft.xml
      mkdir -p $out/share/icons
      cp -R assets/app-icon/hicolor $out/share/icons/
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      APP="$out/Applications/CADCraft.app"

      mkdir -p $APP/Contents/{MacOS,Resources}

      ln -s $out/bin/cadcraft $out/Applications/CADCraft.app/Contents/MacOS/CADCraft

      cp $NIX_BUILD_TOP/source/assets/app-icon/cadcraft.icns $APP/Contents/Resources/CADCraft.icns

      sed -e "s/@VERSION@/${finalAttrs.version}/g" -e "s/@SHORT_VERSION@/${finalAttrs.version}/g" \
        -e "s/@BUILD_SHA@/unknown}/g" \
        "$NIX_BUILD_TOP/source/packaging/macos/Info.plist.in" >"$APP/Contents/Info.plist"
      plutil -lint "$APP/Contents/Info.plist"

      printf 'APPL????' >"$APP/Contents/PkgInfo"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP/Contents/MacOS/CADCraft"
      rcodesign sign \
        --code-signature-flags runtime \
        --entitlements-xml-file "$NIX_BUILD_TOP/source/packaging/macos/entitlements.plist" \
        "$APP"
    '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    patchelf --add-rpath ${lib.makeLibraryPath runtimeDeps} $out/bin/cadcraft
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "2D drafting app for DXF and DWG drawings";
    homepage = "https://github.com/storytold/cadcraft";
    changelog = "https://github.com/storytold/cadcraft/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.mit
      lib.licenses.asl20
    ];
    maintainers = with lib.maintainers; [ sophronesis ];
    mainProgram = "cadcraft";
    platforms = rustc.meta.platforms;
  };
})
