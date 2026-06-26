{
  configuration ? import ./lib/from-env.nix "NIXOS_CONFIG" <nixos-config>,
  system ? builtins.currentSystem,
  # This should only be used for special arguments that need to be evaluated when resolving module structure (like in imports).
  # For everything else, there's _module.args.
  specialArgs ? { },
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
