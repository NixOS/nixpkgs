{
  stdenv,
  lib,
  fetchFromGitHub,
  cargo,
  meson,
  ninja,
  rustPlatform,
  rustc,
  pkg-config,
  glib,
  libshumate,
  gst_all_1,
  gtk4,
  libadwaita,
  pipewire,
  wayland,
  wrapGAppsHook4,
  desktop-file-utils,
  gitUpdater,
  common-updater-scripts,
  _experimental-update-script-combinators,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ashpd-demo";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "ashpd";
    rev = "${finalAttrs.version}-demo";
    hash = "sha256-0IGqA8PM6I2p4/MrptkdSWIZThMoeaMsdMc6tVTI2MU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    src = "${finalAttrs.src}/ashpd-demo";
    hash = "sha256-kUEzVBk8dKXCQdHFJJS633CBG1F57TIxJg1xApMwzbI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    rustPlatform.bindgenHook
    desktop-file-utils
    glib # for glib-compile-schemas
  ];

  buildInputs = [
    glib
    gtk4
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libadwaita
    pipewire
    wayland
    libshumate
  ];

  postPatch = ''
    cd ashpd-demo
  '';

  passthru = {
    updateScript =
      let
        updateSource = gitUpdater {
          url = finalAttrs.src.gitRepoUrl;
          rev-suffix = "-demo";
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
              update-source-version ashpd-demo --ignore-same-version --source-key=cargoDeps.vendorStaging > /dev/null
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
    description = "Tool for playing with XDG desktop portals";
    mainProgram = "ashpd-demo";
    homepage = "https://github.com/bilelmoussaoui/ashpd/tree/master/ashpd-demo";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
})
