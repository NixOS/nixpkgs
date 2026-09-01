{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  gitUpdater,
  usbmuxd,
  libimobiledevice,
  libzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ideviceinstaller";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "ideviceinstaller";
    tag = finalAttrs.version;
    hash = "sha256-V4zJ85wF3jjBlWOY+oxo6veNeiSHVAUBipmokzhRgaI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    usbmuxd
    libimobiledevice
    libzip
  ];

  # the package uses zip_get_num_entries, which is deprecated
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/libimobiledevice/ideviceinstaller";
    description = "List/modify installed apps of iOS devices";
    longDescription = ''
      ideviceinstaller is a tool to interact with the installation_proxy
      of an iOS device allowing to install, upgrade, uninstall, archive, restore
      and enumerate installed or archived apps.
    '';
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "ideviceinstaller";
  };
})
