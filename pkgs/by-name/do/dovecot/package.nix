{
  callPackage,
  dovecot_pigeonhole,
}:
callPackage ./generic.nix { } {
  version = "2.4.2";
  hash = "sha256-LNYuTSK5/ByAvThklzmVDw29o0+8PmJiT7aEImTpPG4=";
  patches = [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];

  inherit dovecot_pigeonhole;
}
