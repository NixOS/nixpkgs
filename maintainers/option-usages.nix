{ configuration ? import ../lib/from-env.nix "NIXOS_CONFIG" /etc/nixos/configuration.nix

# []: display all options
# [<option names>]: display the selected options
, displayOptions ? [
    "hardware.pcmcia.enable"
    "environment.systemPackages"
    "boot.kernelModules"
    "services.udev.packages"
    "jobs"
    "environment.etc"
    "system.activationScripts"
  ]
}:

# This file is used to generate a dot graph which contains all options and
# there dependencies to track problems and their sources.

let
  
  evalFun = {
    extraArgs ? {}
  }: import ../lib/eval-config.nix {
       modules = [ configuration ];
       inherit extraArgs;
     };

  eval = evalFun {};
  inherit (eval) pkgs;

  reportNewFailures = old: new: with pkgs.lib;
    let
      filterChanges =
        filter ({fst, snd}:
          !(fst.config.success -> snd.config.success)
        );

      keepNames =
        map ({fst, snd}:
          assert fst.name == snd.name; snd.name
        );
     in
       keepNames (
         filterChanges (
           zipLists (collect isOption old) (collect isOption new)
         )
       );


  # Create a list of modules where each module contains only one failling
  # options.
  introspectionModules = with pkgs.lib;
    let
      setIntrospection = opt: rec {
        name = opt.name;
        path = splitString "." opt.name;
        config = setAttrByPath path
          (throw "Usage introspection of '${name}' by forced failure.");
      };
    in
      map setIntrospection (collect isOption eval.options);

  overrideConfig = thrower:
    pkgs.lib.recursiveUpdateUntil (path: old: new:
      path == thrower.path
    ) eval.config thrower.config;


  graph = with pkgs.lib;
    map (thrower: {
      option = thrower.name;
      usedBy = reportNewFailures eval.options (evalFun {
        extraArgs = {
          config = overrideConfig thrower;
        };
      }).options;
    }) introspectionModules;

  graphToDot = graph: with pkgs.lib; ''
    digraph "Option Usages" {
      ${concatMapStrings ({option, usedBy}:
          assert __trace option true;
          if displayOptions == [] || elem option displayOptions then
            concatMapStrings (user: ''
              "${option}" -> "${user}"''
            ) usedBy
          else ""
        ) graph}
    }
  '';

in

pkgs.texFunctions.dot2pdf {
  dotGraph = pkgs.writeTextFile {
    name = "option_usages.dot";
    text = graphToDot graph;
  };
}
