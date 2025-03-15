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
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "gpu-screen-recorder-notification";
  version = "1.0.4";

  src = fetchgit {
    url = "https://repo.dec05eba.com/${pname}";
    tag = version;
    hash = "sha256-8nftekHFI07oDdOGhUgSQoMIFYflFDU/unsPrWvURTw=";
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
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Notification in the style of ShadowPlay";
    homepage = "https://git.dec05eba.com/${pname}/about/";
    license = lib.licenses.gpl3Only;
    mainProgram = "gsr-notify";
    maintainers = with lib.maintainers; [ js6pak ];
    platforms = lib.platforms.linux;
  };
}
