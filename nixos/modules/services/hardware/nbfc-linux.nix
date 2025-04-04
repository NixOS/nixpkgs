{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.nbfc-linux;
in
{
  options.services.nbfc-linux = {
    enable = lib.mkEnableOption "NBFC: NoteBook FanControl service";

    configName = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      description = "The NBFC configuration name to use. Obtain the list via `nbfc config --list`";
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."nbfc-linux/config.json".source = pkgs.writeTextFile {
      name = "nbfc-linux-config.json";
      text = (lib.strings.toJSON { SelectedConfigId = cfg.configName; });
      checkPhase = ''
        if ! ${lib.getExe pkgs.nbfc-linux} config --list | grep --fixed-strings --line-regexp --quiet '${cfg.configName}'
        then
          echo "nbfc-linux: configuration '${cfg.configName}' not found in the list of available configurations. Use 'nbfc config --list' to view available configs." >&2
          exit 1
        fi
      '';
    };

    environment.systemPackages = [ pkgs.nbfc-linux ]; # for the CLI
    systemd.packages = [ pkgs.nbfc-linux ];
    systemd.services.nbfc-linux = {
      description = "NoteBook FanControl";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStartPre = "${lib.getExe pkgs.nbfc-linux} wait-for-hwmon";
        ExecStart = "${lib.getExe pkgs.nbfc-linux} start";
        ExecStop = "${lib.getExe pkgs.nbfc-linux} stop";
      };
      path = [ pkgs.nbfc-linux ];
    };
  };
}
