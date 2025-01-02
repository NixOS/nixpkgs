{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  remote-write = import ./remote-write.nix { inherit system pkgs; };
  vmalert = import ./vmalert.nix { inherit system pkgs; };
  external-promscrape-config = import ./external-promscrape-config.nix { inherit system pkgs; };
}
