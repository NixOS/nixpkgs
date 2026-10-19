{ pkgs, ... }:

let
  inherit (pkgs) callPackage;
in

{
  pass-audit = callPackage ./audit { };
  pass-checkup = throw "'pass-checkup' has been removed as it is archived upstream; use pass audit instead."; # Added 2026-10-19
  pass-import = callPackage ./import.nix { };
  pass-otp = callPackage ./otp.nix { };
  pass-tomb = callPackage ./tomb.nix { };
  pass-update = callPackage ./update.nix { };
  pass-genphrase = callPackage ./genphrase.nix { };
  pass-file = callPackage ./file.nix { };
}
