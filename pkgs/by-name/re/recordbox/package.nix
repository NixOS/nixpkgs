{
  lib,
  stdenv,
  appstream-glib,
  blueprint-compiler,
  cargo,
  desktop-file-utils,
  fetchFromGitea,
  glib,
  gst_all_1,
  gtk4,
  hicolor-icon-theme,
  libadwaita,
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
  version = "0.8.3";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "edestcroix";
    repo = "Recordbox";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-/yg/75LswCj3HhsUhMXgIDpx2tlNkdTuImkqMwU6uio=";
  };

  # Patch in our Cargo.lock and ensure AppStream tests don't use the network
  # TODO: Switch back to the default `validate` when the upstream file actually
  # passes it
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock

    substituteInPlace data/meson.build \
      --replace-fail "['validate', appstream_file]" "['validate-relax', '--nonet', appstream_file]"
  '';

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

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

  buildInputs =
    [
      gtk4
      hicolor-icon-theme
      libadwaita
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
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Relatively simple music player";
    homepage = "https://codeberg.org/edestcroix/Recordbox";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "recordbox";
    platforms = lib.platforms.linux;
  };
})
