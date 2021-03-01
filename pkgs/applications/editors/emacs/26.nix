import ./generic.nix (rec {
  version = "26.3";
  sha256 = "119ldpk7sgn9jlpyngv5y4z3i7bb8q3xp4p0qqi7i5nq39syd42d";
  patches = [
    ./clean-env-26.patch
    ./tramp-detect-wrapped-gvfsd-26.patch
  ];
})
