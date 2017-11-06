{ configuration ? import ../nixos/lib/from-env.nix "NIXUP_CONFIG" <nixup-config>
, system ? builtins.currentSystem
}:

let

  eval = import ./lib/eval-config.nix {
    modules = [ configuration { nixpkgs.system = system; } ];
  };

in

{
  inherit (eval) config options;

  profile = eval.config.nixup.build.profile;
}
