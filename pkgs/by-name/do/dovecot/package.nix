import ./generic.nix {
  version = "2.4.5";
  hash = "sha256-oZ9wmfsKSr54DB9NebRl+atuDrCL3johkskY6M1Hxmg=";
  patches = _: [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];
}
