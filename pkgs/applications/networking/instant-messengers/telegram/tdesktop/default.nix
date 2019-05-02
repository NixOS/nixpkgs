{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.6.7";
    sha256Hash = "1537div6pky7wz3lansz67vsx2h6b653cx91xg9sswnxfsf8nrql";
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
