{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  versionCheckHook,
  nix-update-script,

  withRust ? true,
  cargo,
  rustc,
  pkg-config,

  at-spi2-core,
  ayatana-ido,
  cairo,
  gdk-pixbuf,
  glib,
  glib-networking,
  gst_all_1,
  gtk3,
  harfbuzz,
  libayatana-appindicator,
  libayatana-indicator,
  libdbusmenu-gtk3,
  libsoup_3,
  openssl,
  pango,
  pipewire,
  webkitgtk_4_1,
  zlib,

  withDeb ? true,
  withAppImage ? false,
  withArch ? true,
  binutils,
  libarchive,
  withRpm ? false,
  rpm,

  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
}:

let
  pnpm = pnpm_10;

  defaultTargets = lib.concatStringsSep "," (
    lib.optional withDeb "deb"
    ++ lib.optional withAppImage "appimage"
    ++ lib.optional withArch "zst"
    ++ lib.optional withRpm "rpm"
  );

  gstPlugins = [
    gst_all_1.gstreamer.out
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-rs
    pipewire
  ];

  gstPluginPath = lib.makeSearchPath "lib/gstreamer-1.0" gstPlugins;

  libraries = [
    at-spi2-core
    ayatana-ido
    cairo
    gdk-pixbuf
    glib
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    harfbuzz
    libayatana-appindicator
    libayatana-indicator
    libdbusmenu-gtk3
    libsoup_3
    openssl
    pango
    pipewire
    webkitgtk_4_1
    zlib
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "pake";
  version = "3.17.2";

  src = fetchFromGitHub {
    owner = "tw93";
    repo = "Pake";
    tag = "V${finalAttrs.version}";
    hash = "sha256-UbsbrkNHczzwg6B9NkhRi9cofa7IqHnq7zg4bYPqAz4=";
  };

  patches = [
    ./fix-nix-build-workspace-and-cache.patch
    ./fix-linux-runtime-env.patch
  ];

  postPatch = ''
    substituteInPlace src-tauri/src/main.rs \
      --subst-var-by GIO_EXTRA_MODULES "${glib-networking}/lib/gio/modules" \
      --subst-var-by GST_PLUGIN_SYSTEM_PATH_1_0 "${gstPluginPath}"
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-GrX0TXUDzcmyIlQexq90eJiQ+C62kGdC815dJ0AibN4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    makeWrapper
  ];

  strictDeps = true;
  __structuredAttrs = true;

  buildPhase = ''
    runHook preBuild

    pnpm run cli:build
    CI=true pnpm prune --prod
    find node_modules -xtype l -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pake $out/bin
    cp -r dist node_modules package.json src-tauri $out/lib/pake/

    makeWrapper ${nodejs}/bin/node $out/bin/pake \
      --add-flags "$out/lib/pake/dist/cli.js" \
      --prefix PATH : ${
        lib.makeBinPath (
          [
            nodejs
            pnpm
          ]
          ++ lib.optionals withRust [
            cargo
            rustc
            stdenv.cc
            pkg-config
          ]
          ++ lib.optionals withArch [
            binutils
            libarchive
          ]
          ++ lib.optionals withRpm [
            rpm
          ]
          ++ (extraPkgs finalAttrs.finalPackage)
        )
      } \
      --prefix PKG_CONFIG_PATH : "${
        lib.makeSearchPathOutput "dev" "lib/pkgconfig" (
          libraries ++ (extraLibraries finalAttrs.finalPackage)
        )
      }:${
        lib.makeSearchPathOutput "dev" "share/pkgconfig" (
          libraries ++ (extraLibraries finalAttrs.finalPackage)
        )
      }" \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath (libraries ++ (extraLibraries finalAttrs.finalPackage))
      }" \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${gstPluginPath}" \
      --prefix WEBKIT_GST_ALLOWED_URI_PROTOCOLS : "asset" \
      --set-default GST_PLUGIN_FEATURE_RANK "vaav1dec:NONE,vavp9dec:NONE,vah264dec:NONE,vah265dec:NONE,vavp8dec:NONE" \
      --set-default __NV_DISABLE_EXPLICIT_SYNC "1" \
      --set-default RUSTFLAGS "-C link-arg=-Wl,-rpath,${
        lib.makeLibraryPath (libraries ++ (extraLibraries finalAttrs.finalPackage))
      }" \
      --set-default TAURI_LINUX_AYATANA_APPINDICATOR "1" \
      ${lib.optionalString (
        defaultTargets != ""
      ) ''--set-default PAKE_DEFAULT_TARGETS "${defaultTargets}"''}

    runHook postInstall
  '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Turn any webpage into a desktop app with Rust and Tauri";
    homepage = "https://github.com/tw93/Pake";
    changelog = "https://github.com/tw93/Pake/releases/tag/V${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rebizzz ];
    mainProgram = "pake";
    platforms = lib.platforms.unix;
  };
})
