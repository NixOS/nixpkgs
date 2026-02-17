{
  stdenv,
  lib,
  fetchurl,
  cargo,
  desktop-file-utils,
  itstool,
  meson,
  ninja,
  pkg-config,
  rustc,
  wrapGAppsHook4,
  gtk4,
  lcms2,
  libadwaita,
  libgweather,
  libseccomp,
  libglycin,
  glycin-loaders,
  gnome,
  common-updater-scripts,
  _experimental-update-script-combinators,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loupe";
  version = "49.2";

  src = fetchurl {
    url = "mirror://gnome/sources/loupe/${lib.versions.major finalAttrs.version}/loupe-${finalAttrs.version}.tar.xz";
    hash = "sha256-WFPnXM66f6K+oBvic80vCjBhlB573+OgCLIzFxBnFCw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "loupe-deps-${finalAttrs.version}";
    hash = "sha256-9jEz6hcdFUv5Daeh/0co1hHt49bE9kFAbFvnyiEaGJg=";
  };

  postPatch = ''
    substituteInPlace src/meson.build --replace-fail \
      "'src' / rust_target / meson.project_name()," \
      "'src' / '${stdenv.hostPlatform.rust.cargoShortTarget}' / rust_target / meson.project_name()," \
  '';

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    itstool
    libglycin.patchVendorHook
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    libglycin.setupHook
    glycin-loaders
    gtk4
    lcms2
    libadwaita
    libgweather
    libseccomp
  ];

  # For https://gitlab.gnome.org/GNOME/loupe/-/blob/0e6ddb0227ac4f1c55907f8b43eaef4bb1d3ce70/src/meson.build#L34-35
  env.CARGO_BUILD_TARGET = stdenv.hostPlatform.rust.rustcTargetSpec;

  passthru = {
    updateScript =
      let
        updateSource = gnome.updateScript {
          packageName = "loupe";
        };

        updateLockfile = {
          command = [
            "sh"
            "-c"
            ''
              PATH=${
                lib.makeBinPath [
                  common-updater-scripts
                ]
              }
              update-source-version loupe --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
            ''
          ];
          # Experimental feature: do not copy!
          supportedFeatures = [ "silent" ];
        };
      in
      _experimental-update-script-combinators.sequence [
        updateSource
        updateLockfile
      ];
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/loupe";
    changelog = "https://gitlab.gnome.org/GNOME/loupe/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Simple image viewer application written with GTK4 and Rust";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jk ];
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
    mainProgram = "loupe";
  };
})
