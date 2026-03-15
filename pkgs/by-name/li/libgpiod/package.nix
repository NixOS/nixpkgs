{
  lib,
  stdenv,
  fetchgit,
  gitUpdater,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  enable-tools ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libgpiod";
  version = "2.2.3";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QOztbnUzSGZlw03dWctCpQ65wyTp0C5J+FVisldsbxQ=";
  };

  nativeBuildInputs = [
    autoconf-archive
    pkg-config
    autoreconfHook
  ];

  configureFlags = [
    "--enable-tools=${lib.boolToYesNo enable-tools}"
    "--enable-bindings-cxx"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    allowedVersions = "^[0-9\\.]+$";
  };

  meta = {
    description = "C library and tools for interacting with the linux GPIO character device";
    longDescription = ''
      Since linux 4.8 the GPIO sysfs interface is deprecated. User space should use
      the character device instead. This library encapsulates the ioctl calls and
      data structures behind a straightforward API.
    '';
    homepage = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/";
    license =
      with lib.licenses;
      [
        lgpl21Plus # libgpiod
        lgpl3Plus # C++ bindings
      ]
      ++ lib.optional enable-tools gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
