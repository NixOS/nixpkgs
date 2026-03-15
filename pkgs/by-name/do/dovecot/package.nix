import ./generic.nix {
  version = "2.4.2";
  hash = "sha256-uOW0gOernPRb+3fkupTISiQ34An0HEMFrdH0mjmFLKQ=";
  patches = _: [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];
}
