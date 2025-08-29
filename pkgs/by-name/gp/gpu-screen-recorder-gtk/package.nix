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
  libX11,
  libXrandr,
  wayland,
  wrapGAppsHook3,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-gtk";
  version = "5.7.8";

  src = fetchgit {
    url = "https://repo.dec05eba.com/${pname}";
    tag = version;
    hash = "sha256-Vzi7IfiMsBFJZaZwC1CWZkVFCfDAfU0lmO7orRLjqgU=";
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
    libX11
    libXrandr
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
}
