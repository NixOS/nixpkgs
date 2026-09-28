{
  lib,
  stdenv,
  fetchFromGitHub,
  eglexternalplatform,
  pkg-config,
  meson,
  ninja,
  wayland-scanner,
  libGL,
  libdrm,
  wayland,
  wayland-protocols,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "egl-wayland";
  version = "1.1.22";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "egl-wayland";
    tag = finalAttrs.version;
    hash = "sha256-3adLn4Sa2jzeg1uR00fVVLgVGdORlpp1xm7Il5i8xpQ=";
  };

  postPatch = ''
    # Declares an includedir but doesn't install any headers
    # CMake's `pkg_check_modules(NAME wayland-eglstream IMPORTED_TARGET)` considers this an error
    sed -i -e '/includedir/d' wayland-eglstream.pc.in
  '';

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libdrm
    wayland
    wayland-protocols
  ];

  propagatedBuildInputs = [
    eglexternalplatform
  ];

  absolutizeEglExternalPlatformIcdJson = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "EGLStream-based Wayland external platform";
    homepage = "https://github.com/NVIDIA/egl-wayland/";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.freebsd;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
  };
})
