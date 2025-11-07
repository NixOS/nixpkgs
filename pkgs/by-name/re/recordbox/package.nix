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
  libglycin,
  glycin-loaders,
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
  version = "0.10.4";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "edestcroix";
    repo = "Recordbox";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9rrVlD+ODl+U9bPzbXGLQBLkbnfAm4SmJHRcVife33A=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-W60X69/fEq/X6AK1sbT6rb+SsF/oPzfUvrar0fihr88=";
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

  # Workaround copied from https://github.com/NixOS/nixpkgs/blob/e39fe935fc7537bee0440935c12f5c847735a291/pkgs/by-name/lo/loupe/package.nix#L60-L74
  preConfigure = ''
    # Dirty approach to add patches after cargoSetupPostUnpackHook
    # We should eventually use a cargo vendor patch hook instead
    pushd ../$(stripHash $cargoDeps)/glycin-2.*
      patch -p3 < ${libglycin.passthru.glycinPathsPatch}
    popd
  '';
  preFixup = ''
    # Needed for the glycin crate to find loaders.
    # https://gitlab.gnome.org/sophie-h/glycin/-/blob/0.1.beta.2/glycin/src/config.rs#L44
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${glycin-loaders}/share"
    )
  '';

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
