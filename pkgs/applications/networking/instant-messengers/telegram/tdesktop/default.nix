{ qt5, stdenv }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.3.7";
    sha256Hash = "1rwnqgla061icvyvw8gxqd7qki1jnq0f46hvyffp74ng5r1b6wjg";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "310557";
    archPatchesHash = "1v134dal3xiapgh3akfr61vh62j24m9vkb62kckwvap44iqb0hlk";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
  });
}
