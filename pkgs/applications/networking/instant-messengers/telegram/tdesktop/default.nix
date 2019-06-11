{ qt5 }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.7.7";
    sha256Hash = "0w3jq02qzpx58xlmwaj0lgav5lx6s9hdidnq9v1npp4qmpdnsn75";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "476826";
    archPatchesHash = "1vnlvba60hxd5jlh0fvsa50xmb9xgcphdsx6j1ld7f12m7ik68zr";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
