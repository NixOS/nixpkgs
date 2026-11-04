# The options of `wstunnel` that all of its subcommands share, in a module that
# is not specific to a module class. `wstunnel` requires a subcommand, thus this
# module does not give a complete command line. The module of each subcommand,
# for example `wstunnel/server.nix`, imports this module.
# `passthru.commandModules.wstunnel` of `pkgs.wstunnel` exposes it, thus a
# consumer can add a subcommand that does not have a module. See "Modules of a
# package" in the Nixpkgs manual for why it is in this directory.
#
# The consumer sets `package`. The module of each subcommand adds `settings`
# to `portable.argv`, because a subcommand can change how a setting is shown.
# `settings` and `portable.flags` use the same `portable.flagFormat`, thus
# `portable.flags.foo` gives `--foo`, as `settings.foo` does.

{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    getExe
    mkOption
    types
    ;
in
{
  imports = [
    # Not `lib.genericModules`: the `lib` module argument may come from a
    # different Nixpkgs version than this file.
    (lib.modules.importApply ../../../../../../../lib/modules/generic/command-line.nix {
      prefix = [ "portable" ];
    })
  ];

  options = {
    package = mkOption {
      description = "The wstunnel package to use.";
      type = types.package;
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (
          types.oneOf [
            types.bool
            types.int
            types.str
            (types.listOf types.str)
          ]
        );
      };
      default = { };
      description = ''
        Command line arguments to pass to `wstunnel`.
        Attributes of the form `argName = true;` will be translated to `--argName`,
        and `argName = \"value\"` to `--argName value`.
      '';
      example = {
        "someNewOption" = true;
        "someNewOptionWithValue" = "someValue";
      };
    };
  };

  config.portable = {
    executable = getExe config.package;

    # The format of `lib.cli.toCommandLineGNU`.
    flagFormat =
      flag:
      let
        isLong = lib.stringLength flag > 1;
      in
      {
        option = if isLong then "--${flag}" else "-${flag}";
        sep = if isLong then "=" else "";
        explicitBool = false;
      };
  };
}
