{ modules
, stateVersion
}:

let
  lib = import <nixpkgs/lib>;
  # dummy pkgs set that contains no packages, only `pkgs.lib` from the full set.
  # not having `pkgs.lib` causes all users of `pkgs.formats` to fail.
  pkgs = import <nixpkgs/pkgs/pkgs-lib> {
    inherit lib;
    pkgs = throw "pkgs-lib tried to use pkgs for cacheable options build";
  };
  utils = import <nixpkgs/nixos/lib/utils.nix> {
    inherit config lib;
    pkgs = throw "utils.nix tried to use pkgs for cacheable options build";
  };
  # this is used both as a module and as specialArgs.
  # as a module it sets the _module special values, as specialArgs it makes `config`
  # unusable. this causes documentation attributes depending on `config` to fail.
  config = {
    _module.check = false;
    _module.args = {};
    system.stateVersion = stateVersion;
  };
  eval = lib.evalModules {
    modules = (map (m: <nixpkgs/nixos/modules> + "/${m}") modules) ++ [
      config
    ];
    specialArgs = {
      inherit config pkgs utils;
    };
  };
  docs = import <nixpkgs/nixos/lib/make-options-doc> {
    inherit lib;
    pkgs = throw "make-options-doc tried to use pkgs for cacheable options build";
    inherit (eval) options;
  };
in
  docs.optionsNix
