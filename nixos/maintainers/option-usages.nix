{ configuration ? import ../lib/from-env.nix "NIXOS_CONFIG" <nixos-config>

# provide an option name, as a string literal.
, testOption ? null

# provide a list of option names, as string literals.
, testOptions ? [ ]
}:

# This file is made to be used as follow:
#
#   $ nix-instantiate ./option-usages.nix --argstr testOption service.xserver.enable -A txtContent --eval
#
# or
#
#   $ nix-build ./option-usages.nix --argstr testOption service.xserver.enable -A txt -o service.xserver.enable._txt
#
# Other targets exists such as `dotContent`, `dot`, and `pdf`.  If you are
# looking for the option usage of multiple options, you can provide a list
# as argument.
#
#   $ nix-build ./option-usages.nix --arg testOptions \
#      '["boot.loader.gummiboot.enable" "boot.loader.gummiboot.timeout"]' \
#      -A txt -o gummiboot.list
#
# Note, this script is slow as it has to evaluate all options of the system
# once per queried option.
#
# This nix expression works by doing a first evaluation, which evaluates the
# result of every option.
#
# Then, for each queried option, we evaluate the NixOS modules a second
# time, except that we replace the `config` argument of all the modules with
# the result of the original evaluation, except for the tested option which
# value is replaced by a `throw` statement which is caught by the `tryEval`
# evaluation of each option value.
#
# We then compare the result of the evaluation of the original module, with
# the result of the second evaluation, and consider that the new failures are
# caused by our mutation of the `config` argument.
#
# Doing so returns all option results which are directly using the
# tested option result.

with import ../../lib;

let

  evalFun = {
    specialArgs ? {}
  }: import ../lib/eval-config.nix {
       modules = [ configuration ];
       inherit specialArgs;
     };

  eval = evalFun {};
  inherit (eval) pkgs;

  excludedTestOptions = [
    # We cannot evluate _module.args, as it is used during the computation
    # of the modules list.
    "_module.args"

    # For some reasons which we yet have to investigate, some options cannot
    # be replaced by a throw without causing a non-catchable failure.
    "networking.bonds"
    "networking.bridges"
    "networking.interfaces"
    "networking.macvlans"
    "networking.sits"
    "networking.vlans"
    "services.openssh.startWhenNeeded"
  ];

  # for some reasons which we yet have to investigate, some options are
  # time-consuming to compute, thus we filter them out at the moment.
  excludedOptions = [
    "boot.systemd.services"
    "systemd.services"
    "kde.extraPackages"
  ];
  excludeOptions = list:
    filter (opt: !(elem (showOption opt.loc) excludedOptions)) list;


  reportNewFailures = old: new:
    let
      filterChanges =
        filter ({fst, snd}:
          !(fst.success -> snd.success)
        );

      keepNames =
        map ({fst, snd}:
          /* assert fst.name == snd.name; */ snd.name
        );

      # Use  tryEval (strict ...)  to know if there is any failure while
      # evaluating the option value.
      #
      # Note, the `strict` function is not strict enough, but using toXML
      # builtins multiply by 4 the memory usage and the time used to compute
      # each options.
      tryCollectOptions = moduleResult:
        forEach (excludeOptions (collect isOption moduleResult)) (opt:
          { name = showOption opt.loc; } // builtins.tryEval (strict opt.value));
     in
       keepNames (
         filterChanges (
           zipLists (tryCollectOptions old) (tryCollectOptions new)
         )
       );


  # Create a list of modules where each module contains only one failling
  # options.
  introspectionModules =
    let
      setIntrospection = opt: rec {
        name = showOption opt.loc;
        path = opt.loc;
        config = setAttrByPath path
          (throw "Usage introspection of '${name}' by forced failure.");
      };
    in
      map setIntrospection (collect isOption eval.options);

  overrideConfig = thrower:
    recursiveUpdateUntil (path: old: new:
      path == thrower.path
    ) eval.config thrower.config;


  graph =
    map (thrower: {
      option = thrower.name;
      usedBy = assert __trace "Investigate ${thrower.name}" true;
        reportNewFailures eval.options (evalFun {
          specialArgs = {
            config = overrideConfig thrower;
          };
        }).options;
    }) introspectionModules;

  displayOptionsGraph =
     let
       checkList =
         if testOption != null then [ testOption ]
         else testOptions;
       checkAll = checkList == [];
     in
       flip filter graph ({option, ...}:
         (checkAll || elem option checkList)
         && !(elem option excludedTestOptions)
       );

  graphToDot = graph: ''
    digraph "Option Usages" {
      ${concatMapStrings ({option, usedBy}:
          concatMapStrings (user: ''
            "${option}" -> "${user}"''
          ) usedBy
        ) displayOptionsGraph}
    }
  '';

  graphToText = graph:
    concatMapStrings ({usedBy, ...}:
        concatMapStrings (user: ''
          ${user}
        '') usedBy
      ) displayOptionsGraph;

in

rec {
  dotContent = graphToDot graph;
  dot = pkgs.writeTextFile {
    name = "option_usages.dot";
    text = dotContent;
  };

  pdf = pkgs.texFunctions.dot2pdf {
    dotGraph = dot;
  };

  txtContent = graphToText graph;
  txt = pkgs.writeTextFile {
    name = "option_usages.txt";
    text = txtContent;
  };
}
