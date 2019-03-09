{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.5.15";
    sha256Hash = "09m9pcm0yd9x3vz22c7zn2xzcnqc7mkbml8xg1z608nnsd702c51";
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
