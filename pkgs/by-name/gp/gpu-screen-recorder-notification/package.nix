{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  libX11,
  libXrender,
  libXrandr,
  libXext,
  libglvnd,
  wayland,
  wayland-scanner,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-notification";
  version = "1.1.0";

  src = fetchgit {
    url = "https://repo.dec05eba.com/gpu-screen-recorder-notification";
    tag = version;
    hash = "sha256-ODifZ046DEBNiGT3+S6pQyF8ekrb6LIHWton8nv1MBo=";
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
    libX11
    libXrender
    libXrandr
    libXext
    libglvnd
    wayland
    wayland-scanner
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Notification in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/gpu-screen-recorder-notification/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-notify";
    maintainers = with lib.maintainers; [ js6pak ];
    platforms = lib.platforms.linux;
  };
}
