{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.godns;

  settingsFormat = pkgs.formats.yaml { };
in
{

  options.services.godns = {
    enable = mkEnableOption "GoDNS service";

    package = mkPackageOption pkgs "godns" { };

    settings = mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };

      description = ''
        Configuration for GoDNS. Refer to the [configuration section](1) in the
        GoDNS GitHub repository for details.

        [1]: https://github.com/TimothyYe/godns?tab=readme-ov-file#configuration
      '';
    };

    configFile = lib.mkOption {
      description = ''
        Path to a custom GoDNS configuration file.

        If set, this option overrides the configuration provided by the
        `settings` option. This is particularly useful for specifying sensitive
        values like the `login_token` for API providers. For generating a
        configuration file with secrets, consider using [sops-nix templates][1].

        [1]: https://github.com/Mic92/sops-nix?tab=readme-ov-file#templates
      '';
      type = types.path;
    };

    additionalRestartTriggers = mkOption {
      default = [ ];
      type = types.listOf types.unspecified;
      description = ''
        Additional triggers to restart the GoDNS service.

        This can be used to restart the service when, for example, a secret used
        to generate the configuration changes.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.godns.configFile = lib.mkDefault (settingsFormat.generate "config.yaml" cfg.settings);
    systemd.services.godns = {
      description = "GoDNS service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -c ${cfg.configFile}";
        Restart = "always";
        RestartSec = "2s";
      };
      restartTriggers = [ ] ++ cfg.additionalRestartTriggers;
    };
  };

  meta.maintainers = [ lib.maintainers.michaelvanstraten ];
}
