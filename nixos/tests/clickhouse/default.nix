{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  base = import ./base.nix { inherit system pkgs; };
  kafka = import ./kafka.nix { inherit system pkgs; };
  keeper = import ./keeper.nix { inherit system pkgs; };
  s3 = import ./s3.nix { inherit system pkgs; };
}
