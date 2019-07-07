{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.7.10";
    sha256Hash = "04if7siv0ib5sbdkdc7vwmxyjy3fnijrshgc8i8m79marfkn3wac";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "480743";
    archPatchesHash = "0jfyp642l2850yzgrw3irq8bn6vl44rx2693c5cshwbihd212af7";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
