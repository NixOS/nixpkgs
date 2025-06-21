{
  callPackage,
  dovecot_pigeonhole,
  dovecot_exporter,
  dovecot_fts_xapian,
}:
callPackage ./generic.nix { } {
  version = "2.4.0";
  hash = "sha256-6Q5J+MMbCaUIJJpP7oYF+qZf4yCBm/ytryUkEmJT1a4=";
  patches = [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];

  inherit dovecot_pigeonhole dovecot_exporter dovecot_fts_xapian;
}
