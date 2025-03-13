{
  callPackage,
  dovecot_pigeonhole_2_4,
  dovecot_exporter_2_4,
  dovecot_fts_xapian_2_4,
}@args:
callPackage ./generic.nix args {
  version = "2.4.0";
  hash = "sha256-6Q5J+MMbCaUIJJpP7oYF+qZf4yCBm/ytryUkEmJT1a4=";
  patches = [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];

  dovecot_pigeonhole = dovecot_pigeonhole_2_4;
  dovecot_exporter = dovecot_exporter_2_4;
  dovecot_fts_xapian = dovecot_fts_xapian_2_4;
}
