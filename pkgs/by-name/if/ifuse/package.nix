{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse3,
  usbmuxd,
  libimobiledevice,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ifuse";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "libimobiledevice";
    repo = "ifuse";
    tag = finalAttrs.version;
    hash = "sha256-STMELfxbWf2W6NKKqBxgbQLZpYXv9N0cDLgHho5PRYM=";
  };

  env = {
    VER = finalAttrs.version;
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    fuse3
    usbmuxd
    libimobiledevice
  ];

  meta = {
    homepage = "https://github.com/libimobiledevice/ifuse";
    description = "Fuse filesystem implementation to access the contents of iOS devices";
    longDescription = ''
      Mount directories of an iOS device locally using fuse. By default the media
      directory is mounted, options allow to also mount the sandbox container of an
      app, an app's documents folder or even the root filesystem on jailbroken
      devices.
    '';
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
    mainProgram = "ifuse";
  };
})
