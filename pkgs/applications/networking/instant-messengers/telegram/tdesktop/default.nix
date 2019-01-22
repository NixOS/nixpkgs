{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.5.8";
    sha256Hash = "0sl4p4a7fyh68g01rddiy719lyr321cjar78b3c732zxfj8lxvkb";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "415526";
    archPatchesHash = "1lfzws90ab0vajhm5r64gyyqqc1g6a2ay0a1vkp0ah1iw5jh11ik";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
