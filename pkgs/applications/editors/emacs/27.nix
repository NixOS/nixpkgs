import ./generic.nix (rec {
  version = "27.1";
  sha256 = "0h9f2wpmp6rb5rfwvqwv1ia1nw86h74p7hnz3vb3gjazj67i4k2a";
  patches = [
    ./tramp-detect-wrapped-gvfsd.patch
  ];
})
