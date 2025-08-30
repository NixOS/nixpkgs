import ./generic.nix {
  hash = "sha256-Nnig3i21AurzstrIcx+Jca8fMZtNAGbSrB4E8JhatVE=";
  version = "6.16.0";
  vendorHash = "sha256-l8cu+Q6Tpco48iuooVDegk7Fkw9yW1SNfyWQXhcFo4c=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
