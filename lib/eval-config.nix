# From an end-user configuration file (`configuration'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

{ configuration
, system ? builtins.currentSystem
, nixpkgs ? import ./from-env.nix "NIXPKGS" /etc/nixos/nixpkgs
, pkgs ? import nixpkgs {inherit system;}
, extraArgs ? {}
}:

let extraArgs_ = extraArgs; in

rec {
  inherit nixpkgs pkgs;

  configComponents = [
    configuration
    ./check-config.nix
  ] ++ (import ../modules/module-list.nix);

  extraArgs = extraArgs_ // {
    inherit pkgs;
    modulesPath = ../modules;
  };

  config_ =
    pkgs.lib.definitionsOf configComponents extraArgs;

  # "fixableDeclarationsOf" is used instead of "declarationsOf" because some
  # option default values may depends on the definition of other options.
  optionDeclarations =
    pkgs.lib.fixableDeclarationsOf configComponents extraArgs config_;

  # Optionally check wether all config values have corresponding
  # option declarations.
  config = pkgs.checker config_
    config_.environment.checkConfigurationOptions
    optionDeclarations config_;
}
