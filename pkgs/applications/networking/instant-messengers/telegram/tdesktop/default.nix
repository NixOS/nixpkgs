{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.4.0";
    sha256Hash = "1zlsvbk9vgsqwplcswh2q0mqjdqf5md1043paab02wy3qg2x37d8";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "388448";
    archPatchesHash = "06a1j7fxg55d3wgab9rnwv93dvwdwkx7mvsxaywwwiz7ng20rgs1";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
