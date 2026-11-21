# Non-module arguments (`lib.modules.importApply`)
{
  # Attribute path of the options. Modular services use `[ "process" ]`.
  prefix ? [ ],
}:

# The command line of a program, in a module that is not specific to a module
# class. A module of a program sets `flags` from the options of the program, and
# a consumer (a modular service, a wrapper, ...) reads `argv`.
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;

  cfg = lib.getAttrFromPath prefix config;
  opts = lib.getAttrFromPath prefix options;

  # Paths are interpolated rather than `toString`ed on purpose: interpolation
  # copies the path into the store, so the resulting argument still resolves on
  # the machine that runs the program. `toString` would yield the path of the
  # source tree the configuration was evaluated from, which is not there at
  # runtime.
  pathOrStr = types.coercedTo types.path (x: "${x}") types.str;

  # `executable` is the first argument. This priority is lower than that of
  # `lib.mkBefore` (500).
  executablePriority = 0;

  # `argv` and `flags` share a single `lib.mkOrder` space, so flags need a
  # priority. This one sits between `lib.modules.defaultOrderPriority` (1000,
  # what an unadorned `argv` definition gets) and `lib.mkAfter` (1500): plain
  # flags follow plain `argv` entries, while `lib.mkAfter` on `argv` still lands
  # after the flags. See the `flags` option description.
  unadornedFlagPriority = 1250;

  # `attrListWith` re-emits every flag wrapped in `lib.mkOrder`, using
  # `lib.modules.defaultOrderPriority` for flags that carried no ordering
  # property of their own. Rewrite exactly that priority; anything else is an
  # explicit `lib.mkOrder` from the user and is passed through verbatim.
  atFlagPriority =
    def:
    if def.value._type or null == "order" && def.value.priority == lib.modules.defaultOrderPriority then
      def // { value = lib.mkOrder unadornedFlagPriority def.value.content; }
    else
      def;
in
{
  _class = null;

  options = lib.setAttrByPath prefix {
    executable = mkOption {
      type = types.nullOr pathOrStr;
      default = null;
      example = lib.literalExpression "lib.getExe config.package";
      description = ''
        Path of the program to start.

        When set, it is the first entry of `argv`, at `lib.mkOrder ${toString executablePriority}`.
        Thus it comes before the `argv` entries that use `lib.mkBefore`.
        When `null`, set the program in `argv`.
      '';
    };

    argv = mkOption {
      type = types.listOf pathOrStr;
      example = lib.literalExpression ''[ (lib.getExe config.package) "--nobackground" ]'';
      description = ''
        Command filename and arguments of the program.
        This is a raw command-line that should not contain any shell escaping.
        If expansion of environmental variables is required then use
        a shell script or `importas` from `pkgs.execline`.

        When `executable` is set, it is merged into `argv` as the first entry.
        When `flags` are set, the arguments rendered from them are merged into
        `argv`. See `flags` for how the two are ordered against each other.
      '';
    };

    flagFormat = mkOption {
      type = types.functionTo (types.attrsOf types.anything);
      default = name: {
        option = name;
        sep = null;
        explicitBool = false;
      };
      defaultText = lib.literalExpression ''
        name: {
          option = name;
          sep = null;
          explicitBool = false;
        }
      '';
      description = ''
        Function mapping flag names to option format specs
        for `lib.cli.toCommandLine`.

        Receives the flag name and returns `{ option, sep, explicitBool, formatArg? }`.
      '';
      example = lib.literalExpression ''
        name: {
          option = name;
          sep = "=";
          explicitBool = false;
        }
      '';
    };

    flags = mkOption {
      type = types.attrListWith {
        elemType = types.nullOr (
          types.oneOf [
            types.bool
            types.int
            # `pathOrStr`, not `types.path`: `lib.cli.toCommandLine` renders
            # values with `lib.generators.mkValueStringDefault`, which has no
            # case for paths and would abort.
            pathOrStr
          ]
        );
        asAttrs = true;
      };
      default = { };
      description = ''
        Flags to pass to the program.
        The key is the flag name (e.g. `"--port"`), the value is the flag value.

        Each `name = value` pair is rendered via `lib.cli.toCommandLine`
        using `flagFormat`.

        - `null`: the flag is omitted (regardless of `flagFormat`)
        - bool: rendered per `flagFormat.explicitBool`
          - `explicitBool = false` (default): `true` emits the bare flag,
            `false` is omitted
          - `explicitBool = true`: both `true` and `false` are rendered as
            explicit arguments via `flagFormat.formatArg`
        - string / path / int: rendered as the option's argument, joined to the
          option name per `flagFormat.sep` and stringified by
          `flagFormat.formatArg`

        To pass the same flag multiple times, use the list form with
        repeated keys, e.g.
        `[ { "--host" = "a"; } { "--host" = "b"; } ]`.

        The rendered arguments are merged into `argv`, so `argv` and `flags`
        share a single `lib.mkOrder` space:

        - A flag with no ordering property of its own is placed at priority
          1250, between `lib.modules.defaultOrderPriority` (1000, which is
          what an unadorned `argv` definition gets) and `lib.mkAfter` (1500).
          Plain flags therefore follow the command name and any other plain
          `argv` arguments.
        - `lib.mkAfter` on `argv` still lands after the flags, which is how
          trailing positional arguments are expressed.
        - `lib.mkOrder` on a flag is honoured verbatim against `argv`, so a
          sub-command can be placed between two groups of flags.

        Because 1250 is substituted for flags that carry no ordering property,
        `lib.mkOrder 1000` on a flag is indistinguishable from leaving that
        flag unadorned. To order a flag around plain `argv` entries, pick a
        priority next to 1000, such as 999 or 1001.
      '';
      example = lib.literalExpression ''
        {
          "--port" = "8080";
          "--verbose" = true;
          # ordered ahead of the unadorned flags above
          "--config" = lib.mkOrder 1100 "/etc/foo.conf";
        }
        # or, for repeated flags:
        [
          { "--host" = "localhost"; }
          { "--host" = "0.0.0.0"; }
        ]
      '';
    };
  };

  config = lib.setAttrByPath prefix {
    argv = lib.mkMerge [
      (lib.mkIf (cfg.executable != null) (lib.mkOrder executablePriority [ cfg.executable ]))
      (lib.modules.mapDefinitionValue (attr: lib.cli.toCommandLine cfg.flagFormat attr) (
        lib.mkMerge (map atFlagPriority opts.flags.valueMeta.definitions)
      ))
    ];
  };
}
