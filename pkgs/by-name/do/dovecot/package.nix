{ callPackage }@args:
callPackage ./generic.nix args {
  version = "2.4.0";
  hash = "sha256-6Q5J+MMbCaUIJJpP7oYF+qZf4yCBm/ytryUkEmJT1a4=";
  patches = [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];
}
