import ./generic.nix (rec {
  version = "27.2";
  sha256 = "sha256-tKfMTnjmPzeGJOCRkhW5EK9bsqCvyBn60pgnLp9Awbk=";
  patches = fetchpatch: [
    (fetchpatch {
      name = "fix-aarch64-darwin-triplet.patch";
      url = "https://git.savannah.gnu.org/cgit/emacs.git/patch/?id=a88f63500e475f842e5fbdd9abba4ce122cdb082";
      sha256 = "sha256-RF9b5PojFUAjh2TDUW4+HaWveV30Spy1iAXhaWf1ZVg=";
    })
  ];
})
