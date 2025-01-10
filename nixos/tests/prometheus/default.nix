{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

{
  alertmanager = import ./alertmanager.nix { inherit system pkgs; };
  config-reload = import ./config-reload.nix { inherit system pkgs; };
  federation = import ./federation.nix { inherit system pkgs; };
  prometheus-pair = import ./prometheus-pair.nix { inherit system pkgs; };
  pushgateway = import ./pushgateway.nix { inherit system pkgs; };
  remote-write = import ./remote-write.nix { inherit system pkgs; };
}
