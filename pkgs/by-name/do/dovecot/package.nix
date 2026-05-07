import ./generic.nix {
  version = "2.4.3";
  hash = "sha256-NTtQMHK/IzAYHKb1lxClUUJkyJpeLo7mKRCAR1GaUTo=";
  patches = _: [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];
}
