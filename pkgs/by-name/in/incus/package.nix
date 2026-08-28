import ./generic.nix {
  hash = "sha256-9q4YrumeCb8u0O6e0Ftisb33s2dz/DOdUO3JD05W8K0=";
  version = "7.4.0";
  vendorHash = "sha256-zplmn+JH/zEaQgo2xa5wzc6rCIb5tLIVlM1vYJpw9zQ=";
  patches = fetchpatch2: [
    ./go_1_26_6.patch
  ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
