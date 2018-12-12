callArgs:

let
  inherit (builtins.foldl' ({ modules, configurers }: m:
    let
      match = m: builtins.isAttrs m && m ? configureModules;
      return = m: {
        modules = modules ++ [ (removeAttrs m [ "configureModules" ]) ];
        configurers = configurers ++ [ m.configureModules ];
      };
    in if match m then return m else
    let m' = import m; in if !(builtins.isFunction m || builtins.isAttrs m) && match m'
    then return (m' // { _file = toString m; key = toString m; })
    else { modules = modules ++ [ m ]; inherit configurers; }
  ) { modules = []; configurers = []; } callArgs.modules) modules configurers;

  # Without updating the modules list, the `configureModules` attribute
  # would not be removed from its module, and it is an invalid option or special attribute,
  # so it would result in an error.
  callArgs' = callArgs // { inherit modules; };

  applyConfigureModules = x: if builtins.isFunction x
    then x callArgs'
    else callArgs' // x // builtins.listToAttrs (map
      (name: { inherit name; value = callArgs'.${name} // x.${name}; })
      (builtins.filter (name: x ? ${name}) [ "args" "specialArgs" ]));

  configArgs = let len = builtins.length configurers; in if len == 1
    then applyConfigureModules (builtins.head configurers)
    else if len == 0 then callArgs'
    else throw "Only one module (the entry point) is allowed to have a 'configureModules' attribute.";

in
(
  { modules
  , prefix ? []
  , args ? {}
  , specialArgs ? {}
  , lib ? import ./.
  , pkgs ? null
  , check ? true
  }:
  let
    evalModule = rec {
      _file = toString ./eval-modules.nix;
      key = _file;
      config = lib.mkMerge [
        { _module = { inherit args check; }; }
        { _module.args.pkgs = lib.mkIf (pkgs != null) (lib.mkForce pkgs); }
      ];
    };

  in lib.evalModules' {
    inherit prefix;
    modules = modules ++ [ evalModule ];
    specialArgs = { modulesPath = toString ../nixos/modules; } // specialArgs // { inherit lib; };
  }
)
(configArgs)
