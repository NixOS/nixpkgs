{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  fuse,
  fuse3,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.18.0";
  pname = "bindfs";

  src = fetchurl {
    url = "https://bindfs.org/downloads/bindfs-${finalAttrs.version}.tar.gz";
    hash = "sha256-Rvz5W4cRCSZek81C5a4oLHInFkiK2fDaHh+YU1vjf3o=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = if stdenv.hostPlatform.isDarwin then [ fuse ] else [ fuse3 ];

  configureFlags = lib.optional stdenv.hostPlatform.isDarwin "--disable-macos-fs-link";

  postFixup = ''
    ln -s $out/bin/bindfs $out/bin/mount.fuse.bindfs
  '';

  meta = {
    changelog = "https://github.com/mpartel/bindfs/raw/${finalAttrs.version}/ChangeLog";
    description = "FUSE filesystem for mounting a directory to another location";
    homepage = "https://bindfs.org";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      lovek323
      lovesegfault
    ];
    platforms = lib.platforms.unix;
  };
})
