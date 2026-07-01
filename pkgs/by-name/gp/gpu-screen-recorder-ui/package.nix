{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  makeWrapper,
  gpu-screen-recorder,
  gpu-screen-recorder-notification,
  libx11,
  libxrender,
  libxrandr,
  libxcomposite,
  libxi,
  libxcursor,
  libxkbcommon,
  libglvnd,
  libpulseaudio,
  libdrm,
  dbus,
  wayland,
  wayland-scanner,
  pango,
  wrapperDir ? "/run/wrappers/bin",
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-ui";
  version = "1.12.2";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-ui";
    tag = finalAttrs.version;
    hash = "sha256-9hm5Guv+C1++hVmJ43xw9SkyqDv8hJk3SNEImbulLOs=";
  };

  patches = [
    ./remove-gnome-postinstall.patch
  ];

  postPatch = ''
    substituteInPlace depends/mglpp/depends/mgl/src/gl.c \
      --replace-fail "libGL.so.1" "${lib.getLib libglvnd}/lib/libGL.so.1" \
      --replace-fail "libGLX.so.0" "${lib.getLib libglvnd}/lib/libGLX.so.0" \
      --replace-fail "libEGL.so.1" "${lib.getLib libglvnd}/lib/libEGL.so.1"

    substituteInPlace gpu-screen-recorder.desktop \
      --replace-fail "Exec=gsr-ui" "Exec=$out/bin/gsr-ui"
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    makeWrapper
  ];

  buildInputs = [
    libx11
    libxrender
    libxrandr
    libxcomposite
    libxi
    libxcursor
    libxkbcommon
    libglvnd
    libpulseaudio
    libdrm
    dbus
    wayland
    wayland-scanner
    pango
  ];

  mesonBuildType = "release";

  mesonFlags = [
    # Handled by the module
    (lib.mesonBool "capabilities" false)
  ];

  postInstall =
    let
      gpu-screen-recorder-wrapped = gpu-screen-recorder.override {
        inherit wrapperDir;
      };
    in
    ''
      wrapProgram "$out/bin/gsr-ui" \
        --prefix PATH : "${wrapperDir}" \
        --suffix PATH : "${
          lib.makeBinPath [
            gpu-screen-recorder-wrapped
            gpu-screen-recorder-notification
          ]
        }"
    '';

  passthru.updateScript = gitUpdater { };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Fullscreen overlay UI for GPU Screen Recorder in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-ui/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-ui";
    maintainers = with lib.maintainers; [ js6pak ];
    platforms = lib.platforms.linux;
  };
})
