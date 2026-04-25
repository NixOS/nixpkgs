{
  nix-unit,
  nixVersions,
}:

# nix-unit linked against different Nix releases.
# This will get populated over time with nix-unit compiled against all nix versions that nixpkgs supports

{
  nix_2_30 = nix-unit.override {
    nixComponents = nixVersions.nixComponents_2_30;
  };
}
