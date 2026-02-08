{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  docutils,
  libpthread-stubs,
  withIntel ? lib.meta.availableOn stdenv.hostPlatform libpciaccess,
  libpciaccess,
  withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind-light && !stdenv.cc.isClang,
  valgrind-light,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libdrm";
  version = "2.4.131";

  src = fetchurl {
    url = "https://dri.freedesktop.org/libdrm/libdrm-${finalAttrs.version}.tar.xz";
    hash = "sha256-RbqZg7UciWQGo9ZU3oHTE7lTt25jkeJ5cHPVQ8X2F9U=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
    docutils
  ];
  buildInputs = [
    libpthread-stubs
  ]
  ++ lib.optional withIntel libpciaccess
  ++ lib.optional withValgrind valgrind-light;

  mesonFlags = [
    "-Dinstall-test-programs=true"
    "-Dcairo-tests=disabled"
    (lib.mesonEnable "intel" withIntel)
    (lib.mesonEnable "omap" stdenv.hostPlatform.isLinux)
    (lib.mesonEnable "valgrind" withValgrind)
  ]
  ++ lib.optionals stdenv.hostPlatform.isAarch [
    "-Dtegra=enabled"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isLinux) [
    "-Detnaviv=disabled"
  ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://gitlab.freedesktop.org/mesa/drm.git";
      rev-prefix = "libdrm-";
      # Skip versions like libdrm-2_0_2 that happen to go last when
      # sorted.
      ignoredVersions = "_";
    };
  };

  meta = {
    homepage = "https://gitlab.freedesktop.org/mesa/drm";
    downloadPage = "https://dri.freedesktop.org/libdrm/";
    description = "Direct Rendering Manager library and headers";
    longDescription = ''
      A userspace library for accessing the DRM (Direct Rendering Manager) on
      Linux, BSD and other operating systems that support the ioctl interface.
      The library provides wrapper functions for the ioctls to avoid exposing
      the kernel interface directly, and for chipsets with drm memory manager,
      support for tracking relocations and buffers.
      New functionality in the kernel DRM drivers typically requires a new
      libdrm, but a new libdrm will always work with an older kernel.

      libdrm is a low-level library, typically used by graphics drivers such as
      the Mesa drivers, the X drivers, libva and similar projects.
    '';
    license = lib.licenses.mit;
    platforms = lib.subtractLists lib.platforms.darwin lib.platforms.unix;
    maintainers = [ ];
  };
})
