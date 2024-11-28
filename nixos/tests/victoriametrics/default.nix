{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  remote-write = import ./remote-write.nix { inherit system pkgs; };
  vmalert = import ./vmalert.nix { inherit system pkgs; };
}
