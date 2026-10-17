import ./generic.nix {
  hash = "sha256-LYQ7PFYLjXGqztovhvfJ9XR7xpinPvMvKZgiqsAUvbc=";
  version = "7.0.2";
  vendorHash = "sha256-huplVEZrpV5jI2nXJcmtFeY5SPDBSYwoZ1EtvEUY5Q0=";
  patches = fetchpatch2: [ ];
  lts = true;
  nixUpdateExtraArgs = [
    "--version-regex=^v(7\\.0\\.[0-9]+)$"
    "--override-filename=pkgs/by-name/in/incus/lts.nix"
  ];
}
