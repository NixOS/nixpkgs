{
  dbus,
  desktop-file-utils,
  fetchgit,
  gitUpdater,
  gpu-screen-recorder,
  gpu-screen-recorder-notification,
  gsettings-desktop-schemas,
  lib,
  libcap,
  libdrm,
  libglvnd,
  libpulseaudio,
  libx11,
  libxcomposite,
  libxcursor,
  libxext,
  libxfixes,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  linuxHeaders,
  makeWrapper,
  meson,
  ninja,
  pango,
  pkg-config,
  stdenv,
  wayland-scanner,
  wayland,
  wrapperDir ? "/run/wrappers/bin",
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-ui";
  version = "1.12.5";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    tag = finalAttrs.version;
    hash = "sha256-7e73QImlFwZHJOyt8tY3Qs0XHHCRkP3Jy1FeAsTVt44=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
    desktop-file-utils
  ];

  buildInputs = [
    libx11
    libxrandr
    libxrender
    libxkbcommon
    libxcomposite
    libxfixes
    libxext
    libxi
    libxcursor
    libglvnd
    libpulseaudio
    libdrm
    dbus
    linuxHeaders
    wayland
    wayland-scanner
    pango
    libcap
    gsettings-desktop-schemas
  ];

  __structuredAttrs = true;
  strictDeps = true;

  mesonBuildType = "release";

  mesonFlags = [
    # should be handled in the nixos module
    (lib.mesonBool "capabilities" false)
  ];

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram "$out/bin/${finalAttrs.meta.mainProgram}" \
        --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libglvnd ]}" \
        --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "${
          lib.makeBinPath [
            gpu-screen-recorder-wrapped
            gpu-screen-recorder-notification
          ]
        }"
    '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/about";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-ui";
    maintainers = with lib.maintainers; [
      AhmedAmr
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };
})
