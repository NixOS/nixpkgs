{ qt5, stdenv }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.3.0";
    sha256Hash = "1h5zcvd58bjm02b0rfb7fx1nx1gmzdlk1854lm6kg1hd6mqrrb0i";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "310557";
    archPatchesHash = "1v134dal3xiapgh3akfr61vh62j24m9vkb62kckwvap44iqb0hlk";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
    version = "1.3.4";
    sha256Hash = "17xdzyl7jb5g69a2h6fyk67z7s6h2dqjg8j478px6n0br1n420wk";
  });
}
