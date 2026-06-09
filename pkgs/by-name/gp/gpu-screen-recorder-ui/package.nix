{
  stdenv,
  lib,
  fetchgit,
  pkg-config,
  makeWrapper,
  meson,
  ninja,
  wayland-scanner,
  libx11,
  libxrandr,
  libxrender,
  libxcomposite,
  libxfixes,
  libxext,
  libxi,
  libxcursor,
  dbus,
  desktop-file-utils,
  libglvnd,
  libpulseaudio,
  libdrm,
  libxkbcommon,
  wayland,
  pango,
  freetype,
  glib,
  addDriverRunpath,
  gpu-screen-recorder,
  gpu-screen-recorder-notification,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-ui";
  version = "1.12.5";
  strictDeps = true;
  __structuredAttrs = true;
  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    tag = finalAttrs.version;
    hash = "sha256-7e73QImlFwZHJOyt8tY3Qs0XHHCRkP3Jy1FeAsTVt44=";
  };
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    meson
    ninja
    wayland-scanner
    desktop-file-utils
  ];
  buildInputs = [
    libx11
    libxrandr
    libxrender
    libxcomposite
    libxfixes
    libxext
    libxi
    libxcursor
    dbus
    libglvnd
    libpulseaudio
    libdrm
    libxkbcommon
    wayland
    pango
    freetype
    glib
  ];

  postPatch = ''
        find . -name "meson.build" | xargs grep -l "wayland-scanner" | while read f; do
          substituteInPlace "$f" \
            --replace-fail \
              "wayland_scanner = dependency('wayland-scanner', native: true)
    wayland_scanner_path = wayland_scanner.get_variable(pkgconfig: 'wayland_scanner')
    wayland_scanner_prog = find_program(wayland_scanner_path, native: true)" \
              "wayland_scanner_prog = find_program('wayland-scanner', native: true)"
        done
  '';

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram $out/bin/gsr-ui \
        --prefix PATH : ${wrapperDir} \
        --suffix PATH : ${
          lib.makeBinPath [
            gpu-screen-recorder-wrapped
            gpu-screen-recorder-notification
          ]
        } \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            libglvnd
            addDriverRunpath.driverLink
          ]
        }
    '';
  passthru = {
    updateScript = gitUpdater { };
    globalHotkeys = "${placeholder "out"}/bin/gsr-global-hotkeys";
  };
  meta = {
    description = "Fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gpu-screen-recorder-ui";
    maintainers = with lib.maintainers; [
      mowmdown
    ];
    platforms = lib.platforms.linux;
  };
})
