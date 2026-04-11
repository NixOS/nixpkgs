{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  vulkan-loader,
  libxrandr,
  libxinerama,
  libxcursor,
  libx11,
  libxi,
  libxext,
  libxxf86vm,
  fixDarwinDylibNames,
  wayland,
  wayland-scanner,
  wayland-protocols,
  libxkbcommon,
  libdecor,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "glfw";
  version = "3.4";

  src = fetchFromGitHub {
    owner = "glfw";
    repo = "GLFW";
    tag = finalAttrs.version;
    hash = "sha256-FcnQPDeNHgov1Z07gjFze0VMz2diOrpbKZCsI96ngz0=";
  };

  # Fix linkage issues on X11 (https://github.com/NixOS/nixpkgs/issues/142583)
  patches = [ ./x11.patch ];

  propagatedBuildInputs = lib.optionals (!stdenv.hostPlatform.isWindows) [ libGL ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ fixDarwinDylibNames ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wayland-scanner ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    wayland
    wayland-protocols
    libxkbcommon
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
    libxxf86vm
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/wl_init.c \
      --replace-fail '"libdecor-0.so.0"' '"${lib.getLib libdecor}/lib/libdecor-0.so.0"' \
      --replace-fail '"libwayland-client.so.0"' '"${lib.getLib wayland}/lib/libwayland-client.so.0"' \
      --replace-fail '"libwayland-cursor.so.0"' '"${lib.getLib wayland}/lib/libwayland-cursor.so.0"' \
      --replace-fail '"libwayland-egl.so.1"' '"${lib.getLib wayland}/lib/libwayland-egl.so.1"' \
      --replace-fail '"libxkbcommon.so.0"' '"${lib.getLib libxkbcommon}/lib/libxkbcommon.so.0"'
  '';

  cmakeFlags = [
    # Static linking isn't supported
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
  ];

  env = lib.optionalAttrs (!stdenv.hostPlatform.isDarwin && !stdenv.hostPlatform.isWindows) {
    NIX_CFLAGS_COMPILE = toString [
      "-D_GLFW_GLX_LIBRARY=\"${lib.getLib libGL}/lib/libGLX.so.0\""
      "-D_GLFW_EGL_LIBRARY=\"${lib.getLib libGL}/lib/libEGL.so.1\""
      "-D_GLFW_OPENGL_LIBRARY=\"${lib.getLib libGL}/lib/libGL.so.1\""
      "-D_GLFW_GLESV1_LIBRARY=\"${lib.getLib libGL}/lib/libGLESv1_CM.so.1\""
      "-D_GLFW_GLESV2_LIBRARY=\"${lib.getLib libGL}/lib/libGLESv2.so.2\""
      "-D_GLFW_VULKAN_LIBRARY=\"${lib.getLib vulkan-loader}/lib/libvulkan.so.1\""
      # This currently omits _GLFW_OSMESA_LIBRARY. Is it even used?
    ];
  };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Multi-platform library for creating OpenGL contexts and managing input, including keyboard, mouse, joystick and time";
    homepage = "https://www.glfw.org/";
    license = lib.licenses.zlib;
    maintainers = with lib.maintainers; [
      Scrumplex
      twey
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
