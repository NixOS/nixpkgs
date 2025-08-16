{
  lib,
  stdenv,
  appstream-glib,
  blueprint-compiler,
  cargo,
  dbus,
  desktop-file-utils,
  fetchFromGitea,
  glib,
  gst_all_1,
  gtk4,
  hicolor-icon-theme,
  lcms2,
  libadwaita,
  libseccomp,
  libxml2,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  rustPlatform,
  rustc,
  sqlite,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "recordbox";
  version = "0.10.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "edestcroix";
    repo = "Recordbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o2cKVRpuAwE+/TI5mwtSvkCFaXN349GP9dDlgdh3Luk=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-0/tKL5UW1QuhsddivU/r8n3T3xyRaGLRVpKuXcc4fmU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    appstream-glib # For `appstream-util`
    blueprint-compiler
    cargo
    desktop-file-utils # For `desktop-file-validate`
    glib # For `glib-compile-schemas`
    gtk4 # For `gtk-update-icon-cache`
    libxml2 # For `xmllint`
    meson
    ninja
    pkg-config
    rustPlatform.cargoCheckHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    gtk4
    hicolor-icon-theme
    lcms2
    libadwaita
    libseccomp
    sqlite
  ]
  ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gst-plugins-rs
    gst-plugins-ugly
    gstreamer
  ]);

  mesonBuildType = "release";

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  cargoCheckType = if (finalAttrs.mesonBuildType != "debug") then "release" else "debug";

  checkPhase = ''
    runHook preCheck

    mesonCheckPhase
    cargoCheckHook

    runHook postCheck
  '';

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--generate-lockfile" ]; };
  };

  meta = {
    description = "Relatively simple music player";
    homepage = "https://codeberg.org/edestcroix/Recordbox";
    changelog = "https://codeberg.org/edestcroix/Recordbox/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "recordbox";
    platforms = lib.platforms.linux;
  };
})
