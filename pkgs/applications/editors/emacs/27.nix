import ./generic.nix (rec {
  version = "27.2";
  sha256 = "sha256-tKfMTnjmPzeGJOCRkhW5EK9bsqCvyBn60pgnLp9Awbk=";
  patches = fetchpatch: [
    (fetchpatch {
      name = "fix-aarch64-darwin-triplet.patch";
      url = "https://git.savannah.gnu.org/cgit/emacs.git/patch/?id=a88f63500e475f842e5fbdd9abba4ce122cdb082";
      sha256 = "sha256-RF9b5PojFUAjh2TDUW4+HaWveV30Spy1iAXhaWf1ZVg=";
    })
    # glibc 2.34 compat
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/emacs/raw/181aafcdb7ee2fded9fce4cfc448f27edccc927f/f/emacs-glibc-2.34.patch";
      sha256 = "sha256-2o3C/jhZPl2OW/LmVPt/fhdwbS9NOdF9lVEF1Kn9aEk=";
    })
  ];
})
