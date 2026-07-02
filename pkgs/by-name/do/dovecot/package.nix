import ./generic.nix {
  version = "2.4.4";
  hash = "sha256-vy0R8TWQQ3BSOyTtWoa65CYgUfsJqkIU6QfnnzaqrI4=";
  patches = _: [
    # Fix loading extended modules.
    ./load-extended-modules.patch
  ];
}
