{
  lib,
  stdenv,
  fetchurl,
  libglut,
  libGL,
  libGLU,
  libx11,
  libxcb,
  libxext,
  libgbm,
  mesa,
  meson,
  ninja,
  pkg-config,
  wayland,
  wayland-scanner,
  wayland-protocols,
  vulkan-loader,
  libxkbcommon,
  libdecor,
  glslang,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mesa-demos";
  version = "9.0.0";

  src = fetchurl {
    url = "https://archive.mesa3d.org/demos/mesa-demos-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-MEaj0mp7BRr3690lel8jv+sWDK1u2VIynN/x6fHtSWs=";
  };

  outputs = [
    "out"
    "utils"
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    glslang
  ];

  buildInputs = [
    libglut
    libx11
    libxcb
    libxext
    libGL
    libGLU
    libgbm
    wayland
    wayland-protocols
    vulkan-loader
    libxkbcommon
    libdecor
  ];

  mesonFlags = [
    "-Degl=${if stdenv.hostPlatform.isDarwin then "disabled" else "auto"}"
    (lib.mesonEnable "libdrm" (stdenv.hostPlatform.isLinux))
    (lib.mesonEnable "osmesa" false)
    (lib.mesonEnable "wayland" (lib.meta.availableOn stdenv.hostPlatform wayland))
  ];

  # Split the essential utilities into a `utils` output (re-exposed top-level
  # as `mesa-utils`). For backwards compatibility, symlink them back into
  # `$out/bin/` so existing consumers of `mesa-demos` keep working unchanged.
  postInstall = ''
    for bin in \
      eglinfo eglgears_wayland eglgears_x11 eglkms \
      egltri_wayland egltri_x11 peglgears xeglgears xeglthreads \
      es2_info es2gears_wayland es2gears_x11 es2tri \
      glxinfo glxgears \
      vkgears; do
      if [ -e "$out/bin/$bin" ]; then
        moveToOutput "bin/$bin" "$utils"
        ln -s "$utils/bin/$bin" "$out/bin/$bin"
      fi
    done
  '';

  meta = {
    inherit (mesa.meta) homepage platforms;
    description = "Collection of demos and test programs for OpenGL and Mesa";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andersk ];
  };
})
