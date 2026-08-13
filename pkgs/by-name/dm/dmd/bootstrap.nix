{ callPackage }:
callPackage ./binary.nix {
  version = "2.090.1";
  hashes = {
    # Get these from `nix-prefetch-url http://downloads.dlang.org/releases/2.x/2.090.1/dmd.2.090.1.linux.tar.xz` etc..
    osx = "sha256-9HwGVO/8jfZ6aTiDIUi8w4C4Ukry0uUS8ACP3Ig8dmU=";
    linux = "sha256-ByCrIA4Nt7i9YT0L19VXIL1IqIp+iObcZux407amZu4=";
  };
}
