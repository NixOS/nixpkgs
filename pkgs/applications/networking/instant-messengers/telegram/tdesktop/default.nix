{ qt5, stdenv }:

let
  mkTelegram = args: qt5.callPackage (import ./generic.nix args) { };
  stableVersion = {
    stable = true;
    version = "1.2.17";
    sha256Hash = "1lswjn3rnrbps1pd2xhnhggcn1z0i7y71dpr0v9wb1yc8qhh4pi0";
    # svn log svn://svn.archlinux.org/community/telegram-desktop/trunk
    archPatchesRevision = "310557";
    archPatchesHash = "1v134dal3xiapgh3akfr61vh62j24m9vkb62kckwvap44iqb0hlk";
  };
in {
  stable = mkTelegram stableVersion;
  preview = mkTelegram (stableVersion // {
    stable = false;
    version = "1.2.24";
    sha256Hash = "0rrji2h2a7fxdl4wmbwj053vwy3hhbaphymjim55klpzj86jycil";
  });
}
