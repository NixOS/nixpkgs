{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.cloudfoundry-cli;
in
{
  options.programs.cloudfoundry-cli = {
    enable = lib.mkEnableOption "the Cloud Foundry CLI";

    package = lib.mkPackageOption pkgs "cloudfoundry-cli" { };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.cloudfoundryCliPlugins.multiapps ]";
      description = ''
        List of Cloud Foundry CLI plugins to install.

        The plugins are made available to {command}`cf` via a read-only
        {env}`CF_PLUGIN_HOME` in the Nix store, so plugins cannot be installed
        or uninstalled imperatively with {command}`cf install-plugin` unless
        {env}`CF_PLUGIN_HOME` is overridden.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (if cfg.plugins == [ ] then cfg.package else cfg.package.withPlugins (_: cfg.plugins))
    ];
  };

  meta.maintainers = with lib.maintainers; [ vo1dsh4d0w ];
}
