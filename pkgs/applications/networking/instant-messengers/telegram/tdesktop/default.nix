{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.5.12";
    sha256Hash = "1kmibjb907ya4i6n55djn5k2mlxijhh8xj9bjr22zlhi1mc8bkfh";
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
