{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.3.10";
    sha256Hash = "0i1lzks8pf627658w6p7dz87d6cl4g98031qm166npkc40f89bpr";
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
