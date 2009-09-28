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


  mkProtect = name: value: { _type = "protect"; inherit name value; };
  isProtected = attr: (pkgs.lib.typeOf attr) == "protect";

  getName = set: with pkgs.lib;
    if isProtected set then
      set.name
    else
      getName (head (attrValues set));

  rmProtect = set: with pkgs.lib;
    if isProtected set then
      set.value
    else
      mapAttrs (n: rmProtect) set;

  # Create a list of modules where each module contains only one failling
  # options.
  introspectionModules = with pkgs.lib;
    let
      genericFun = f: set:
        fold (name: rest:
          (map (v:
            listToAttrs [(nameValuePair name v)]
          ) (f (getAttr name set)))
          ++ rest
        ) [] (attrNames set);

      addIntrospection = opt: mkProtect opt.name (
        throw "Usage introspection of '${opt.name}' by forced failure."
      );

      f = v:
        if isOption v then
          [(addIntrospection v)]
        else
          genericFun f v;
    in
      genericFun f eval.options;

  overrideConfig = override: with pkgs.lib;
    let f = configs:
      zip (n: v:
        if tail v == [] || isProtected (head v) then
          head v
        else
          f v
      ) configs;
    in
      f [ override eval.config ];


  graph = with pkgs.lib;
    map (thrower: {
      option = getName thrower;
      usedBy = reportNewFailures eval.options (evalFun {
        extraArgs = {
          config = overrideConfig (rmProtect thrower);
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
