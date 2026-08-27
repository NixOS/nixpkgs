{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  fuse3,
  macfuse-stubs,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.18.4";
  pname = "bindfs";

  src = fetchurl {
    url = "https://bindfs.org/downloads/bindfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-MmbQqreHqTKLuw7VYaNx4Z8f8HcnPmaEypKpD+2y/iQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = if stdenv.hostPlatform.isDarwin then [ macfuse-stubs ] else [ fuse3 ];

  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "--disable-macos-fs-link";

  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    changelog = "https://github.com/mpartel/bindfs/raw/${finalAttrs.version}/ChangeLog";
    description = "FUSE filesystem for mounting a directory to another location";
    homepage = "https://bindfs.org";
    license = lib.licenses.gpl2Only;
    mainProgram = "bindfs";
    maintainers = with lib.maintainers; [
      fidgetingbits
      lovesegfault
    ];
    platforms = lib.platforms.unix;
  };
})
