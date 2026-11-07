{
  lib,
  stdenv,
  fetchzip,
  qt6,
  cmake,
  json_c,
  mesa_glu,
  libglut,
  trace-cmd,
  pkg-config,
  libtraceevent,
  libtracefs,
  freefont_ttf,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kernelshark";
  version = "2.4.0";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/utils/trace-cmd/kernel-shark.git/snapshot/kernelshark-v${finalAttrs.version}.tar.gz";
    hash = "sha256-OT6ClyZRE+pxWwm+sfzvN3CnoCIyxcAiVsi1fdzaT4M=";
  };

  patches = [
    # kernelshark: Allow building with CMake 4+
    (fetchpatch {
      url = "https://lore.kernel.org/linux-trace-devel/20251010131715.1123934-1-michal.sojka@cvut.cz/raw";
      hash = "sha256-hT+EhauFlQGjhXyq7Z9FwjS3C+0Jlz6n5BDKCXwzBCc=";
    })
  ];

  outputs = [ "out" ];

  nativeBuildInputs = [
    pkg-config
    cmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtscxml
    qt6.qtwayland
    json_c
    mesa_glu
    libglut
    libtraceevent
    libtracefs
    trace-cmd
  ];

  cmakeFlags = [
    "-D_INSTALL_PREFIX=${placeholder "out"}"
    "-D_POLKIT_INSTALL_PREFIX=${placeholder "out"}"
    "-DPKG_CONGIG_DIR=${placeholder "out"}/lib/pkgconfig"
    "-DTT_FONT_FILE=${freefont_ttf}/share/fonts/truetype/FreeSans.ttf"
  ];

  meta = {
    description = "GUI for trace-cmd which is an interface for the Linux kernel ftrace subsystem";
    homepage = "https://kernelshark.org/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ basvandijk ];
  };
})
