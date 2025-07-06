{
  callPackage,
  fetchpatch,
  dovecot_pigeonhole_2_3,
  dovecot_exporter_2_3,
  dovecot_fts_xapian_2_3,
}:
callPackage ./generic.nix { } {
  version = "2.3.21.1";
  hash = "sha256-LZCheMQpdhEIi/farlSSo7w9WrYyjDoDLrQl0sJJCX4=";
  patches = [
    # Fix loading extended modules.
    ./load-extended-modules.patch
    # fix openssl 3.0 compatibility
    (fetchpatch {
      url = "https://salsa.debian.org/debian/dovecot/-/raw/debian/1%252.3.19.1+dfsg1-2/debian/patches/Support-openssl-3.0.patch";
      hash = "sha256-PbBB1jIY3jIC8Js1NY93zkV0gISGUq7Nc67Ul5tN7sw=";
    })
  ];

  dovecot_pigeonhole = dovecot_pigeonhole_2_3;
  dovecot_exporter = dovecot_exporter_2_3;
  dovecot_fts_xapian = dovecot_fts_xapian_2_3;
}
