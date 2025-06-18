{
  callPackage,
  fetchpatch,
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
    (fetchpatch {
      name = "dovecot-test-data-stack-drop-bogus-assertion.patch";
      url = "https://github.com/dovecot/core/commit/9f642dd868db6e7401f24e4fb4031b5bdca8aae7.patch";
      hash = "sha256-dAX80dRqOba9Fkzl11ChYJ6vqcgfkaw/o+TOQKCnnns=";
    })
  ];
}
