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
  version = "1.0.0-unstable-2024-09-27";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "idevicerestore";
    rev = "511261e12d23d80cc3c08290022380b8d3411f9c";
    hash = "sha256-wviQYTEeNjaYM3hJwMS+/hjjp4jvVtvY/mA88DAboN0=";
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
