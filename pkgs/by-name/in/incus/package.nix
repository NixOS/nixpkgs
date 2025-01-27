import ./generic.nix {
  hash = "sha256-bi++GJLLYlX8JZwmxx4S2EGALuwVOGW4G7u2Nv6s26k=";
  version = "6.9.0";
  vendorHash = "sha256-aYQOKO5RMPqChV6hXPBfSLKdfCuS+BFVmpakJX7swKg=";
  patches = [ ];
  nixUpdateExtraArgs = [
    "--override-filename=pkgs/by-name/in/incus/package.nix"
  ];
}
