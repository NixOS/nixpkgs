{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  meson,
  ninja,
  docutils,
  libpthreadstubs,
  withIntel ? lib.meta.availableOn stdenv.hostPlatform libpciaccess,
  libpciaccess,
  withValgrind ? lib.meta.availableOn stdenv.hostPlatform valgrind-light,
  valgrind-light,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "libdrm";
  version = "2.4.124";

  src = fetchurl {
    url = "https://dri.freedesktop.org/${pname}/${pname}-${version}.tar.xz";
    hash = "sha256-rDYpP2HKSq+vSxaip6//MSqk9cN8n715fenjwIY8o3k=";
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
  buildInputs =
    [ libpthreadstubs ]
    ++ lib.optional withIntel libpciaccess
    ++ lib.optional withValgrind valgrind-light;

  mesonFlags =
    [
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

  meta = with lib; {
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
    license = licenses.mit;
    platforms = lib.subtractLists platforms.darwin platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
