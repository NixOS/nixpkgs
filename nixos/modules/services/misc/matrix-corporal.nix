{ lib, pkgs, config, ... }:
let
  cfg = config.services.matrix-corporal;
in
{
  options.services.matrix-corporal = {
    enable = lib.mkEnableOption "Enable matrix-corporal";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.matrix-corporal;
    };

    settings = lib.mkOption {
      default = {};
      description = ''
        Configuration for matrix-corporal, see <link xlink:href="https://github.com/devture/matrix-corporal/blob/master/docs/configuration.md"/>
        for supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.matrix-corporal = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        DynamicUser="yes";
        ExecStart = "${cfg.package}/bin/matrix-corporal -c ${pkgs.writeTextFile {name = "matrix-corporal-config.json"; text = lib.generators.toJSON {} cfg.settings;}}";
      };
    };
  };
}
