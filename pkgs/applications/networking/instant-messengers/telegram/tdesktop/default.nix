{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.3.13";
    sha256Hash = "00xm3dv9x500v0c21azd98laqij7awyjbas5vyd2dnf2aw9n9qr2";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "359861";
    archPatchesHash = "15xybfs9k6dww747if8z6m9sh7anvqi76zsx2gxyna2j1z36i0r0";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
