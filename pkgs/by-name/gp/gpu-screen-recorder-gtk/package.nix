{
  stdenv,
  lib,
  fetchgit,
  pkg-config,
  addDriverRunpath,
  desktop-file-utils,
  makeWrapper,
  meson,
  ninja,
  gtk3,
  libayatana-appindicator,
  libpulseaudio,
  libdrm,
  gpu-screen-recorder,
  libglvnd,
  libx11,
  libxrandr,
  wayland,
  wrapGAppsHook3,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-gtk";
  version = "5.7.9";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-gtk";
    tag = finalAttrs.version;
    hash = "sha256-RFY5hQqv5XkLliB3+YJX4TXLxV9y1/P8PIYMi6MCbww=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    pkg-config
    makeWrapper
    meson
    ninja
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libayatana-appindicator
    libpulseaudio
    libdrm
    libx11
    libxrandr
    wayland
  ];

  preFixup =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      gappsWrapperArgs+=(--prefix PATH : ${wrapperDir})
      gappsWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ gpu-screen-recorder-wrapped ]})
      gappsWrapperArgs+=(--prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libglvnd
          addDriverRunpath.driverLink
        ]
      })
    '';

  passthru.updateScript = gitUpdater { };

  meta = {
    changelog = "https://git.dec05eba.com/gpu-screen-recorder-gtk/tree/com.dec05eba.gpu_screen_recorder.appdata.xml#n82";
    description = "GTK frontend for gpu-screen-recorder";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-gtk/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gpu-screen-recorder-gtk";
    maintainers = with lib.maintainers; [
      babbaj
      js6pak
    ];
    platforms = [ "x86_64-linux" ];
  };
})
