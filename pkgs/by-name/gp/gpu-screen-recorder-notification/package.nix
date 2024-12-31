{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  libx11,
  libxrender,
  libxrandr,
  libxext,
  libxkbcommon,
  libglvnd,
  wayland,
  wayland-scanner,
  pango,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gpu-screen-recorder-notification";
  version = "1.3.0";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
    tag = finalAttrs.version;
    hash = "sha256-32d6GlX00fStQOu9h/fgOoUjKsZd+/xp7O4nlAeEYII=";
  };

  postPatch = ''
    substituteInPlace depends/mglpp/depends/mgl/src/gl.c \
      --replace-fail "libGL.so.1" "${lib.getLib libglvnd}/lib/libGL.so.1" \
      --replace-fail "libGLX.so.0" "${lib.getLib libglvnd}/lib/libGLX.so.0" \
      --replace-fail "libEGL.so.1" "${lib.getLib libglvnd}/lib/libEGL.so.1"
  '';

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];

  buildInputs = [
    libx11
    libxrender
    libxrandr
    libxext
    libxkbcommon
    libglvnd
    wayland
    wayland-scanner
    pango
  ];

  mesonBuildType = "release";

  passthru.updateScript = gitUpdater { };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Notification in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-notify";
    maintainers = with lib.maintainers; [ js6pak ];
    platforms = lib.platforms.linux;
  };
})
