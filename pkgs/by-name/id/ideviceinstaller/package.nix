{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  libimobiledevice,
  libzip,
  usbmuxd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ideviceinstaller";
  version = "1.1.1-unstable-2024-05-18";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "ideviceinstaller";
    rev = "1431d42b568ee78161a41ed02df0de60dc1439d6";
    hash = "sha256-aXnh2ydukKILPhLv4eSu73IUEZhpin8abaw9e4UCTRk=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    libimobiledevice
    libzip
    usbmuxd
  ];

  # the package uses zip_get_num_entries, which is deprecated
  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=deprecated-declarations"
  ];

  preAutoreconf = ''
    export RELEASE_VERSION=${finalAttrs.version}
  '';

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/ideviceinstaller";
    description = "List/modify installed apps of iOS devices";
    longDescription = ''
      ideviceinstaller is a tool to interact with the installation_proxy
      of an iOS device allowing to install, upgrade, uninstall, archive, restore
      and enumerate installed or archived apps.
    '';
    license = licenses.gpl2Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      aristid
      frontear
    ];
    mainProgram = "ideviceinstaller";
  };
})
