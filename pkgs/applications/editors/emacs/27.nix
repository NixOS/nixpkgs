import ./generic.nix (rec {
  version = "27.2";
  sha256 = "sha256-tKfMTnjmPzeGJOCRkhW5EK9bsqCvyBn60pgnLp9Awbk=";
  patches = [
    ./tramp-detect-wrapped-gvfsd.patch
  ];
})
