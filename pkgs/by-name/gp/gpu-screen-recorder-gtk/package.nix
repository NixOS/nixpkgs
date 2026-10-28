{
  lib,
  stdenv,
  addDriverRunpath,
  desktop-file-utils,
  fetchgit,
  gitUpdater,
  gpu-screen-recorder,
  gtk3,
  libayatana-appindicator,
  libdrm,
  libglvnd,
  libpulseaudio,
  libx11,
  libxrandr,
  makeWrapper,
  meson,
  ninja,
  pkg-config,
  wayland,
  wrapGAppsHook3,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-gtk";
  version = "5.8.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-gtk";
    tag = finalAttrs.version;
    hash = "sha256-LOaHYk7c8USZz5p17YdzcgGJ+FZkEt1qn15VggnQyJQ=";
  };

  nativeBuildInputs = [
    addDriverRunpath
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

  mesonBuildType = "release";

  preFixup =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      gappsWrapperArgs+=(--prefix PATH : ${wrapperDir})
      gappsWrapperArgs+=(--suffix PATH : ${lib.makeBinPath [ gpu-screen-recorder-wrapped ]})
    '';

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ libglvnd ]} $out/bin/.gpu-screen-recorder-gtk-wrapped
    addDriverRunpath $out/bin/.gpu-screen-recorder-gtk-wrapped
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "GTK frontend for gpu-screen-recorder";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-gtk/about/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      babbaj
      js6pak
      keenanweaver
    ];
    platforms = lib.platforms.linux;
    mainProgram = "gpu-screen-recorder-gtk";
  };
})
