{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.4.0";
    sha256Hash = "1zlsvbk9vgsqwplcswh2q0mqjdqf5md1043paab02wy3qg2x37d8";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "388730";
    archPatchesHash = "1gvisz36bc6bl4zcpjyyk0a2dl6ixp65an8wgm2lkc9mhkl783q7";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
