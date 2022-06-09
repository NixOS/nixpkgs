{ config, lib, extendModules, ... }:
let
  inherit (lib) mkOption types;

  extendModule = module: extendModules { modules = [ module ]; };

  extend = module: (extendModule module).config.result;

  inMatrixModule = choiceName: {
    config = {
      _matrixAttrsDone.${choiceName} = {};
    };
  };

  choice = choice@{ name, ... }: {
    options = {
      after = mkOption {
        description = ''
          > You've already made the choice, now you have to understand it.

          Some choices depend on other choices.

          For example, we wouldn't be able to decide about the cookie before
          we take the pill. Deciding the cookie is not possible without
          crucial values set by the pill. To avoid an error like `The option
          'pill' is used but not defined`, we force the ordering.

          ```nix
            matrix.cookie = {
              after = ["pill"];
            };
          ```
        '';
        type = types.listOf types.str;
        default = [];
      };
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          > But if you already know, how can I make a choice?

          > Because you didn't come here to make the choice, you've already made it. You're here to try to understand why you made it.

          Some choices don't make sense, because of earlier choices you've made.

          With this option, you can make Nix understand that, pruning nonsensical
          decisions from the returned tree of tests, so that we don't need to
          compute more than necessary.

          ```nix
          matrix.cookie = {
            after = ["pill"];
            enable = config.pill == "red";
            # ...
          ```

          If we chose the blue pill, we would never have to make a choice about
          the cookie, so we skip this choice.
        '';
      };
      value = mkOption {
        type = types.lazyAttrsOf (extendModule (inMatrixModule choice.name)).type;
      };
    };
  };
in
{
  options = {
    matrix = mkOption {
      type = types.lazyAttrsOf (types.submodule choice);
      description = ''
        Wake up, Neo...

        Like every other test, it is born into a prison that it cannot smell or taste or touch. A prison for the mind... Unfortunately, no one can be told what the matrix option is. You have to see it for yourself. This is your last chance. After this, there is no turning back.

        You define

        ```nix
          matrix.pill.value.blue = { config, ... }: {
            defaults.networking.domain = "bed.home.lan";
          };
        ```

        and wake up in your bed and believe whatever you want to believe.

        You define

        ```nix
          matrix.pill.value.red = { config, ... }: {
            defaults.networking.domain = "wonderland.example.com";
          };
        ```

        you test in wonderland, and I show you how deep the rabbit hole goes...

        Remember, all I'm offering is the multiverse... Follow me...


      '';
      default = {};
    };
    _matrixAttrsDone = mkOption {
      type = types.attrsOf (types.enum [{}]);
      default = {};
    };
    result = mkOption {
      type = types.raw;
    };
  };
  config = {
    result = let
      choicesRemaining = lib.filterAttrs (choice: v: ! config._matrixAttrsDone?${choice}) config.matrix;
      isBefore = a: b:
        if lib.elem a.name b.value.after
        then true
        else if lib.elem b.name a.value.after
        then false
        else a.name < b.name;
      sorted = lib.toposort isBefore (lib.mapAttrsToList lib.nameValuePair choicesRemaining);
      sortedList =
        if sorted ? cycle then
          throw "The matrix.<choice>.after relation contains a paradox of causality.\n\n> You see, there is only one constant, one universal, it is the only\n> real truth: causality. Action. Reaction. Cause and effect.\n      -- The Merovingian, Matrix Reloaded, Lilly and Lana Wachowski\n\nPlease break the cycle:\n${prettyCycle}"
        else sorted.result;
      prettyCycle =
        lib.concatMapStrings (x: "  ${x.name}     --after-->\n") (sorted.cycle)
         + "  ${(lib.head sorted.cycle).name}";
      sortedEnable = lib.filter (c: c.value.enable) sortedList;
      nextChoice = (lib.head sortedEnable).name;
    in
      if sortedEnable == []
      then
        {
          # Make a fixed selection of `run` attributes, so we can return
          # a result attrset spine (names + thunks) without evaluating
          # anything heavy.
          # This makes `extend` next to 0-cost.
          inherit (config.run)
            outputs
            out
            outPath
            outputName
            drvPath
            meta
            name
            system
            type
            ;

          inherit extend;
        } // config.passthru
      else lib.recurseIntoAttrs (
        { inherit extend; } //
        lib.mapAttrs' (k: v: lib.nameValuePair "${nextChoice}-${k}" v.result) config.matrix.${nextChoice}.value
      );
  };
}
