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
  glycin-loaders,
  gnome,
  common-updater-scripts,
  _experimental-update-script-combinators,
  rustPlatform,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "loupe";
  version = "48.1";

  src = fetchurl {
    url = "mirror://gnome/sources/loupe/${lib.versions.major finalAttrs.version}/loupe-${finalAttrs.version}.tar.xz";
    hash = "sha256-EHE9PpZ4nQd659M4lFKl9sOX3fQ6UMBxy/4tEnJZcN4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) src;
    name = "loupe-deps-${finalAttrs.version}";
    hash = "sha256-PKkyZDd4FLWGZ/kDKWkaSV8p8NDniSQGcR9Htce6uCg=";
  };

  nativeBuildInputs = [
    cargo
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    rustc
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glycin-loaders
    gtk4
    lcms2
    libadwaita
    libgweather
    libseccomp
  ];

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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/loupe";
    changelog = "https://gitlab.gnome.org/GNOME/loupe/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Simple image viewer application written with GTK4 and Rust";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jk ];
    teams = [ teams.gnome ];
    platforms = platforms.unix;
    mainProgram = "loupe";
  };
})
