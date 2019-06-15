{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.7.7";
    sha256Hash = "0w3jq02qzpx58xlmwaj0lgav5lx6s9hdidnq9v1npp4qmpdnsn75";
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
