import ./generic.nix {
  hash = "sha256-I+wwpsFGDX0W7pwzROGW1ZDHx+C7uc61ypO45BzOhoE=";
  version = "6.23.0";
  vendorHash = "sha256-R4q0FNu33qZrHrZQTqPCfw7FNUv6itl7y2AxdRF19CQ=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
