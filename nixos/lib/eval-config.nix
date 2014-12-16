# From an end-user configuration file (`configuration'), build a NixOS
# configuration object (`config') from which we can retrieve option
# values.

{ system ? builtins.currentSystem
, pkgs ? null
, baseModules ? import ../modules/module-list.nix
, extraArgs ? {}
, modules
, check ? true
, prefix ? []
}:

let extraArgs_ = extraArgs; pkgs_ = pkgs; system_ = system;
    extraModules = let e = builtins.getEnv "NIXOS_EXTRA_MODULE_PATH";
                   in if e == "" then [] else [(import (builtins.toPath e))];
in rec {

  # Merge the option definitions in all modules, forming the full
  # system configuration.
  inherit (pkgs.lib.evalModules {
    inherit prefix;
    modules = modules ++ extraModules ++ baseModules;
    args = extraArgs;
    check = check && options.environment.checkConfigurationOptions.value;
  }) config options;

  # These are the extra arguments passed to every module.  In
  # particular, Nixpkgs is passed through the "pkgs" argument.
  # FIXME: we enable config.allowUnfree to make packages like
  # nvidia-x11 available. This isn't a problem because if the user has
  # ‘nixpkgs.config.allowUnfree = false’, then evaluation will fail on
  # the 64-bit package anyway. However, it would be cleaner to respect
  # nixpkgs.config here.
  extraArgs = extraArgs_ // {
    inherit pkgs modules baseModules;
    modulesPath = ../modules;
    pkgs_i686 = import ./nixpkgs.nix { system = "i686-linux"; config.allowUnfree = true; };
    utils = import ./utils.nix pkgs;
  };

  # Import Nixpkgs, allowing the NixOS option nixpkgs.config to
  # specify the Nixpkgs configuration (e.g., to set package options
  # such as firefox.enableGeckoMediaPlayer, or to apply global
  # overrides such as changing GCC throughout the system), and the
  # option nixpkgs.system to override the platform type.  This is
  # tricky, because we have to prevent an infinite recursion: "pkgs"
  # is passed as an argument to NixOS modules, but the value of "pkgs"
  # depends on config.nixpkgs.config, which we get from the modules.
  # So we call ourselves here with "pkgs" explicitly set to an
  # instance that doesn't depend on nixpkgs.config.
  pkgs =
    if pkgs_ != null
    then pkgs_
    else import ./nixpkgs.nix (
      let
        system = if nixpkgsOptions.system != "" then nixpkgsOptions.system else system_;
        nixpkgsOptions = (import ./eval-config.nix {
          inherit system extraArgs modules prefix;
          # For efficiency, leave out most NixOS modules; they don't
          # define nixpkgs.config, so it's pointless to evaluate them.
          baseModules = [ ../modules/misc/nixpkgs.nix ../modules/config/no-x-libs.nix ];
          pkgs = import ./nixpkgs.nix { system = system_; config = {}; };
          check = false;
        }).config.nixpkgs;
      in
      {
        inherit system;
        inherit (nixpkgsOptions) config;
      });

}
