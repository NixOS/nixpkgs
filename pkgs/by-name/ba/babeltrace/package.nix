{
  lib,
  stdenv,
  fetchurl,
  gitUpdater,
  autoreconfHook,
  pkg-config,
  glib,
  libuuid,
  popt,
  elfutils,
  enablePython ? false,
  pythonPackages ? null,
  swig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "babeltrace";
  version = "1.5.11";

  src = fetchurl {
    url = "https://www.efficios.com/files/babeltrace/babeltrace-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Z7Q6qu9clR+nrxpVfPcgGhH+iYdrfCK6CgPLwxbbWpw=";
  };

  nativeBuildInputs =
    [
      # The pre-generated ./configure script uses an old autoconf version which
      # breaks cross-compilation (replaces references to malloc with rpl_malloc).
      # Re-generate with nixpkgs's autoconf. This requires glib to be present in
      # nativeBuildInputs for its m4 macros to be present.
      autoreconfHook
      glib
      pkg-config
    ]
    ++ lib.optionals enablePython [
      swig
      pythonPackages.setuptools
    ];
  buildInputs = [
    glib
    libuuid
    popt
    elfutils
  ];

  configureFlags =
    [
      # --enable-debug-info (default) requires the configure script to run host
      # executables to determine the elfutils library version, which cannot be done
      # while cross compiling.
      (lib.enableFeature (stdenv.hostPlatform == stdenv.buildPlatform) "debug-info")
    ]
    ++ lib.optionals enablePython [
      # Using (lib.enableFeature enablePython "python-bindings") makes the
      # configure script look for python dependencies even when
      # enablePython==false. Adding the configure flag conditionally seems to
      # solve this.
      "--enable-python-bindings"
    ];
  #

  passthru.updateScript = gitUpdater {
    url = "https://git.efficios.com/babeltrace.git";
    rev-prefix = "v";
    # Versions 2.x are packaged independently as babeltrace2
    allowedVersions = "^1\\.";
  };

  meta = {
    description = "Command-line tool and library to read and convert LTTng tracefiles";
    homepage = "https://www.efficios.com/babeltrace";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      bjornfor
      wentasah
    ];
  };
})
