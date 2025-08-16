import ./generic.nix {
  hash = "sha256-B29HLuw48j7/Er7p/sHen7ohbbACsAjzPr9Nn8eZNR0=";
  version = "6.0.5";
  vendorHash = "sha256-KOJqPvp+w7G505ZMJ1weRD2SATmfq1aeyCqmbJ6WMAY=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
