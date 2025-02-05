{
  lib,
  stdenv,
  fetchFromGitHub,
  libbsd,
  libuuid,
  openssl,
}:
stdenv.mkDerivation rec {
  pname = "hfsprogs";
  version = "627.40.1-linux";

  src = fetchFromGitHub {
    owner = "glaubitz";
    repo = "hfs";
    rev = "a9496556b0a5fa805139ea20b44081d48aae912a";
    hash = "sha256-i6fXPWHU03ErUN2irP2cLJbpqi1OrTtcQE+ohAz+Eio=";
  };

  buildInputs = [
    libbsd
    libuuid
    openssl
  ];

  installPhase = ''
    # Copy executables
    install -Dm 555 "newfs_hfs/newfs_hfs" "$out/bin/mkfs.hfsplus"
    install -Dm 555 "fsck_hfs/fsck_hfs" "$out/bin/fsck.hfsplus"
    # Copy man pages
    install -Dm 444 "newfs_hfs/newfs_hfs.8" "$out/share/man/man8/mkfs.hfsplus.8"
    install -Dm 444 "fsck_hfs/fsck_hfs.8" "$out/share/man/man8/fsck.hfsplus.8"
  '';

  meta = {
    description = "HFS/HFS+ user space utils";
    license = lib.licenses.apple-psl20;
    platforms = lib.platforms.linux;
  };
}
