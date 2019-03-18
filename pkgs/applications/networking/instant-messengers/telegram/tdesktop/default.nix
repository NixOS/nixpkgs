{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.6.0";
    sha256Hash = "0cspz2kbibrb19l0wbad2dbr0c9ibz153vgd4s45byqn3b5v6h6p";
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
