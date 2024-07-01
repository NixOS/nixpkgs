{ configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>
, system ? builtins.currentSystem
, specialArgs ? {}
}:

let

  eval = import ./lib/eval-config.nix {
    inherit system specialArgs;
    modules = [ configuration ];
  };

in

{
  inherit (eval) pkgs config options;

  system = eval.config.system.build.toplevel;

  inherit (eval.config.system.build) vm vmWithBootLoader;
}
