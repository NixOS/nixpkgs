{
  lib,
  stdenv,
  fetchgit,
  gitUpdater,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  libgudev,
  glib,
  enable-tools ? true,
  enable-dbus ? false,
}:

stdenv.mkDerivation rec {
  pname = "libgpiod";
  version = "2.2.2";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git";
    tag = "v${version}";
    hash = "sha256-MePv6LsK+8zCxG8l4vyiiZPSVqv9F4H4KQB0gHjm0YM=";
  };

  nativeBuildInputs = [
    autoconf-archive
    pkg-config
    autoreconfHook
  ];

  buildInputs =
    [ ]
    ++ lib.optionals enable-dbus [
      libgudev
      glib
    ];

  configureFlags = [
    "--enable-tools=${lib.boolToYesNo enable-tools}"
    "--enable-bindings-cxx"
    "--enable-dbus=${if enable-dbus then "yes" else "no"}"
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    allowedVersions = "^[0-9\\.]+$";
  };

  meta = with lib; {
    description = "C library and tools for interacting with the linux GPIO character device";
    longDescription = ''
      Since linux 4.8 the GPIO sysfs interface is deprecated. User space should use
      the character device instead. This library encapsulates the ioctl calls and
      data structures behind a straightforward API.
    '';
    homepage = "https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/about/";
    license =
      with licenses;
      [
        lgpl21Plus # libgpiod
        lgpl3Plus # C++ bindings
      ]
      ++ lib.optional enable-tools gpl2Plus;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
