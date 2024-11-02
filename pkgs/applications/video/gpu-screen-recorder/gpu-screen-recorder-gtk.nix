{
  stdenv,
  lib,
  fetchurl,
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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-gtk";
  version = "4.2.3";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder-gtk.git.${finalAttrs.version}.tar.gz";
    hash = "sha256-pMUjglgRM51hjPbt6VP0aqM0oo7IiyPXTY/kLwwdR/k=";
  };

  sourceRoot = ".";

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

  meta = {
    changelog = "https://git.dec05eba.com/gpu-screen-recorder-gtk/tree/com.dec05eba.gpu_screen_recorder.appdata.xml#n82";
    description = "GTK frontend for gpu-screen-recorder.";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-gtk/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gpu-screen-recorder-gtk";
    maintainers = with lib.maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
})
