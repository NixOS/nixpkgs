import ./generic.nix {
  hash = "sha256-FdoJI0SUH8KS3Epyw/HejgyhISWGLePsIjYUS2YTBvc=";
  version = "6.5.0";
  vendorHash = "sha256-8e2X7HIy1IEx6p41SHJyq5dNUJ3rRC2maXC4uNaSlnk=";
  patches = [
    # qemu 9.1 compat, remove in 6.6
    ./572afb06f66f83ca95efa1b9386fceeaa1c9e11b.patch
    ./58eeb4eeee8a9e7f9fa9c62443d00f0ec6797078.patch
    ./0c37b7e3ec65b4d0e166e2127d9f1835320165b8.patch
  ];
}
