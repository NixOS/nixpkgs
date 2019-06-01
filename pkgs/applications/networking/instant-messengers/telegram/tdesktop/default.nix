{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.7.3";
    sha256Hash = "0y0chdfxq75ydx8lz40yfpbx8ycm8vdkl5dvll6glxjq5m21kxf9";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "476826";
    archPatchesHash = "1vnlvba60hxd5jlh0fvsa50xmb9xgcphdsx6j1ld7f12m7ik68zr";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
