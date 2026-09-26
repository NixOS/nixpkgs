{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.nushell;
in
{
  options.programs.nushell = {
    enable = lib.mkEnableOption "nushell";

    package = lib.mkPackageOption pkgs "nushell" { };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.nushellPlugins.formats ]";
      description = ''
        List of nushell plugins to install to `lib/nushell/plugins/`.

        Plugins are registered via nushell's vendor autoload on the first
        interactive launch of each user. After registration, plugins persist
        in the user's `plugin.msgpackz` and can be managed at runtime with
        `plugin rm` and `plugin add`.

        See https://www.nushell.sh/book/plugins.html.
      '';
    };

    autoloads = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        Vendor autoload scripts to install. The default location is
        `share/nushell/vendor/autoload/<name>.nu`.

        By default, when `programs.nushell.plugins` is non-empty, a
        script that registers the listed plugins via `plugin add` is
        generated here.

        Set this to override the generated script(s).
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nushell.autoloads = lib.mkDefault (
      lib.optional (cfg.plugins != [ ]) (
        pkgs.writeTextDir "share/nushell/vendor/autoload/50-nixos-plugins.nu" (
          lib.concatLines (map (p: "plugin add ${lib.getExe p}") cfg.plugins)
        )
      )
    );

    environment.systemPackages = [
      cfg.package
    ]
    ++ cfg.plugins
    ++ cfg.autoloads;

    environment.pathsToLink = [ "/share/nushell" ];
  };
}
