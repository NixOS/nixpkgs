import ./generic.nix {
  hash = "sha256-Kqz1fF/0jvqOtYqYSPI37M5vmqNrpfdZx2isbLcJTJg=";
  version = "7.5.1";
  vendorHash = "sha256-erg2ull2Dvw4lXIcjDyS/HVObqYUIh7k4GUsTJ61giY=";
  patches = fetchpatch2: [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
