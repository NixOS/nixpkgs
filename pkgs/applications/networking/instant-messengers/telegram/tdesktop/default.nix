{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.5.4";
    sha256Hash = "0a52m5qkvk01yl3za3k7pccjrqkr8gbxqnj5lnhh1im1pdxqwh4m";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "415526";
    archPatchesHash = "1lfzws90ab0vajhm5r64gyyqqc1g6a2ay0a1vkp0ah1iw5jh11ik";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
    version = "1.5.7";
    sha256Hash = "0mpnz287ahzrcr50ira6h6ry5jjhp5wqi660s3kncxpq1wllj0h6";
  });
}
