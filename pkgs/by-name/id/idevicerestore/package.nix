{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  curl,
  libimobiledevice,
  libirecovery,
  libtatsu,
  libusbmuxd,
  libzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "idevicerestore";
  version = "1.0.0-unstable-2024-10-15";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "idevicerestore";
    rev = "151c680feb6a0775d1b979dbdfca2ac6fdfc8cad";
    hash = "sha256-6a6bRW3nquzlxfA4yDEN3GAyn7JSPRwzKCGK6zLSrAE=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    curl
    libimobiledevice
    libirecovery
    libtatsu
    libusbmuxd
    libzip
    # Not listing other dependencies specified in
    # https://github.com/libimobiledevice/idevicerestore/blob/8a882038b2b1e022fbd19eaf8bea51006a373c06/README#L20
    # because they are inherited `libimobiledevice`.
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/idevicerestore";
    description = "Restore/upgrade firmware of iOS devices";
    longDescription = ''
      The idevicerestore tool allows to restore firmware files to iOS devices.

      It is a full reimplementation of all granular steps which are performed during
      restore of a firmware to a device.

      In general, upgrades and downgrades are possible, however subject to
      availability of SHSH blobs from Apple for signing the firmare files.

      To restore a device to some firmware, simply run the following:
      $ sudo idevicerestore -l

      This will download and restore a device to the latest firmware available.
    '';
    license = licenses.lgpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      frontear
      nh2
    ];
    mainProgram = "idevicerestore";
  };
})
