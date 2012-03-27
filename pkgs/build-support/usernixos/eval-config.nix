{ system ? builtins.currentSystem
, pkgs ? null
, baseModules ? import ./module-list.nix
, extraArgs ? {}
, modules
}:

let extraArgs_ = extraArgs; pkgs_ = pkgs; system_ = system; in

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
  };

  config = systemModule.config;
}
