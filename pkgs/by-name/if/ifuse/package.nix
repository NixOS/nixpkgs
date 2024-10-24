{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,

  autoreconfHook,
  pkg-config,

  fuse,
  libimobiledevice,
  usbmuxd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "ifuse";
  version = "1.1.4-unstable-2023-01-06";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "ifuse";
    rev = "814a0e38050850937debd697fcfe6eca3de1b66f";
    hash = "sha256-bjd/47hzveEJIbuT/C8h+uzGFbXLHupEV/OOOAdNlsc=";
  };

  passthru.updateScript = unstableGitUpdater { };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    fuse
    libimobiledevice
    usbmuxd
  ];

  meta = with lib; {
    homepage = "https://github.com/libimobiledevice/ifuse";
    description = "Fuse filesystem implementation to access the contents of iOS devices";
    longDescription = ''
      Mount directories of an iOS device locally using fuse. By default the media
      directory is mounted, options allow to also mount the sandbox container of an
      app, an app's documents folder or even the root filesystem on jailbroken
      devices.
    '';
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ frontear ];
    mainProgram = "ifuse";
  };
})
