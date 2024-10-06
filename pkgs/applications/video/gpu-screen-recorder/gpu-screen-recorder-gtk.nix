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
  version = "4.1.11";

  src = fetchurl {
    url = "https://dec05eba.com/snapshot/gpu-screen-recorder-gtk.git.${finalAttrs.version}.tar.gz";
    hash = "sha256-aLdzMOtKGR0llt+CyTVVX5xc18L9ddlYApe+dcqGRWY=";
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
    description = "GTK frontend for gpu-screen-recorder.";
    mainProgram = "gpu-screen-recorder-gtk";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-gtk/about/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ babbaj ];
    platforms = [ "x86_64-linux" ];
  };
})
