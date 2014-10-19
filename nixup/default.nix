{ configuration ? import ./lib/from-env.nix "NIX_USER_CONFIG" <nixup-config>
, system ? builtins.currentSystem
}:

let
  eval = import ./lib/eval-config.nix {
    modules = [ configuration { nixpkgs.system = system; } ];
  };

  inherit (eval) pkgs;
in

{
  inherit (eval) config options;

  profile = eval.config.user.build.profile;
}
