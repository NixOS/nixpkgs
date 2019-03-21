{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.6.1";
    sha256Hash = "1gy5al5m1hks0z98cya9kkfinh6k1i8a1d97cy7x6gj0jgmgs88k";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "429149";
    archPatchesHash = "1ylpi9kb6hk27x9wmna4ing8vzn9b7247iya91pyxxrpxrcrhpli";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
