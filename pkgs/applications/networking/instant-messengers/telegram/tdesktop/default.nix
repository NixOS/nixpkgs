{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.5.2";
    sha256Hash = "0kg1xw1b4zj5a2yf6x5r7wrpl7w0fs52s58w606n9gyx7kdcgkj8";
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
