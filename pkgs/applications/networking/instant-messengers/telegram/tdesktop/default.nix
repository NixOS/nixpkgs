{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.5.1";
    sha256Hash = "1y2fhw57g6raiv820sb53hjsqrmm81ij58dxlrv64z7ng0s8cnar";
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
