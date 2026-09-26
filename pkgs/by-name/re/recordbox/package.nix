{
  lib,
  stdenv,
  appstream-glib,
  blueprint-compiler,
  cargo,
  dbus,
  desktop-file-utils,
  fetchFromCodeberg,
  glib,
  glycin-loaders,
  gst_all_1,
  gtk4,
  hicolor-icon-theme,
  lcms2,
  libadwaita,
  libglycin,
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
  version = "0.11.0";

  src = fetchFromCodeberg {
    owner = "edestcroix";
    repo = "Recordbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HskhMZy8y61c/j/F5e5aM41AQ8t+TCUq/iY23SFB92o=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-xHukIMUG5himj1umKn+IKM7kJ29MH/pt/jPEHd2EeT0=";
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
    libglycin.patchVendorHook
    meson
    ninja
    pkg-config
    rustPlatform.cargoCheckHook
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
  ];

  buildInputs = [
    libglycin.setupHook
    glycin-loaders
    dbus
    gtk4
    hicolor-icon-theme
    lcms2
    libadwaita
    libseccomp
    sqlite
  ]
  ++ (with gst_all_1; [
    gst-libav
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
