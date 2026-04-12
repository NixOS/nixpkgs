# Non-module arguments
# These are separate from the module arguments to avoid implicit dependencies.
# This makes service modules self-contains, allowing mixing of Nixpkgs versions.
{ pkgs }:

# The module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib) mkOption types;
  pathOrStr = types.coercedTo types.path (x: "${x}") types.str;
in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";
  imports = [
    ../../modules/generic/meta-maintainers.nix
    ../../nixos/modules/misc/assertions.nix
    (lib.modules.importApply ./config-data.nix { inherit pkgs; })
  ];
  options = {
    services = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          modules = [
            (lib.modules.importApply ./service.nix { inherit pkgs; })
          ];
        }
      );
      description = ''
        A collection of [modular services](https://nixos.org/manual/nixos/unstable/#modular-services) that are configured in one go.

        You could consider the sub-service relationship to be an ownership relation.
        It **does not** automatically create any other relationship between services (e.g. systemd slices), unless perhaps such a behavior is explicitly defined and enabled in another option.
      '';
      default = { };
      visible = "shallow";
    };
    process = {
      argv = mkOption {
        type = types.listOf pathOrStr;
        example = lib.literalExpression ''[ (lib.getExe config.package) "--nobackground" ]'';
        description = ''
          Command filename and arguments for starting this service.
          This is a raw command-line that should not contain any shell escaping.
          If expansion of environmental variables is required then use
          a shell script or `importas` from `pkgs.execline`.

          When `flags` are set, the generated arguments are appended to `argv`.
        '';
      };
      flagFormat = mkOption {
        type = types.functionTo (types.attrsOf types.anything);
        default = name: {
          option = name;
          sep = null;
          explicitBool = false;
        };
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
              types.str
              types.bool
              types.int
            ]
          );
          asAttrs = true;
        };
        default = { };
        description = ''
          Flags to pass to the service process.
          The key is the flag name (e.g. `"--port"`), the value is the flag value.

          Each `name = value` pair is rendered via `lib.cli.toCommandLine`
          using `flagFormat`.

          - `null`: the flag is omitted (regardless of `flagFormat`)
          - bool: rendered per `flagFormat.explicitBool`
            - `explicitBool = false` (default): `true` emits the bare flag,
              `false` is omitted
            - `explicitBool = true`: both `true` and `false` are rendered as
              explicit arguments via `flagFormat.formatArg`
          - string / int: rendered as the option's argument, joined to the
            option name per `flagFormat.sep` and stringified by
            `flagFormat.formatArg`

          To pass the same flag multiple times, use the list form with
          repeated keys, e.g.
          `[ { "--host" = "a"; } { "--host" = "b"; } ]`.

          Use `lib.mkOrder` to influence ordering between flags
          (lower = earlier, default 1000).

          The generated arguments are appended to `argv`.
        '';
        example = lib.literalExpression ''
          {
            "--port" = "8080";
            "--verbose" = true;
            "--config" = lib.mkOrder 500 "/etc/foo.conf";
          }
          # or, for repeated flags:
          [
            { "--host" = "localhost"; }
            { "--host" = "0.0.0.0"; }
          ]
        '';
      };
    };
  };
  config = {
    process.argv = lib.mkAfter (
      lib.concatMap (
        item: lib.cli.toCommandLine config.process.flagFormat item
      ) options.process.flags.valueMeta.attrListValue
    );
  };
}
