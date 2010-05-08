# From an end-user configuration file (`configuration'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

{ system ? builtins.currentSystem
, nixpkgs ? import ./from-env.nix "NIXPKGS" /etc/nixos/nixpkgs
, services ? ../../services
, pkgs ? null
, baseModules ? import ../modules/module-list.nix
, extraArgs ? {}
, modules
}:

let extraArgs_ = extraArgs; pkgs_ = pkgs; in

rec {

  # These are the NixOS modules that constitute the system configuration.
  configComponents = modules ++ baseModules;

  # Merge the option definitions in all modules, forming the full
  # system configuration.  It's not checked for undeclared options.
  systemModule =
    pkgs.lib.fixMergeModules configComponents extraArgs;

  optionDefinitions = systemModule.config;
  optionDeclarations = systemModule.options;
  inherit (systemModule) options;

  # These are the extra arguments passed to every module.  In
  # particular, Nixpkgs is passed through the "pkgs" argument.
  extraArgs = extraArgs_ // {
    inherit pkgs modules baseModules;
    modulesPath = ../modules;
    servicesPath = services;
  };

  # Import Nixpkgs, allowing the NixOS option nixpkgs.config to
  # specify the Nixpkgs configuration (e.g., to set package options
  # such as firefox.enableGeckoMediaPlayer, or to apply global
  # overrides such as changing GCC throughout the system).  This is
  # tricky, because we have to prevent an infinite recursion: "pkgs"
  # is passed as an argument to NixOS modules, but the value of "pkgs"
  # depends on config.nixpkgs.config, which we get from the modules.
  # So we call ourselves here with "pkgs" explicitly set to an
  # instance that doesn't depend on nixpkgs.config.
  pkgs =
    if pkgs_ != null
    then pkgs_
    else import nixpkgs (
      let
        nixpkgsOptions = (import ./eval-config.nix {
          inherit system nixpkgs services extraArgs modules;
          # For efficiency, leave out most NixOS modules; they don't
          # define nixpkgs.config, so it's pointless to evaluate them.
          baseModules = [ ../modules/misc/nixpkgs.nix ];
          pkgs = import nixpkgs { inherit system; config = {}; };
        }).optionDefinitions.nixpkgs;
      in
      {
        inherit system;
        inherit (nixpkgsOptions) config platform;
      });

  # Optionally check wether all config values have corresponding
  # option declarations.
  config =
    let doCheck = optionDefinitions.environment.checkConfigurationOptions; in
    assert doCheck -> pkgs.lib.checkModule "" systemModule;
    systemModule.config;
}
