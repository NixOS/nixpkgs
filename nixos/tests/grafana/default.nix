{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../../.. { inherit system config; }
}:

{
  basic = import ./basic.nix { inherit system pkgs; };
  provision-datasources = import ./provision-datasources { inherit system pkgs; };
  provision-dashboards = import ./provision-dashboards { inherit system pkgs; };
  provision-notifiers = import ./provision-notifiers.nix { inherit system pkgs; };
  provision-rules = import ./provision-rules { inherit system pkgs; };
  provision-contact-points = import ./provision-contact-points { inherit system pkgs; };
  provision-policies = import ./provision-policies { inherit system pkgs; };
  provision-templates = import ./provision-templates { inherit system pkgs; };
  provision-mute-timings = import ./provision-mute-timings { inherit system pkgs; };
}
