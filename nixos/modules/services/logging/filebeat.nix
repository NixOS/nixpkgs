{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.filebeat;

  filebeatYml = pkgs.writeText "filebeat.yml" ''
    ${cfg.extraConfig}
  '';

  # This is extremely ugly.
  # Using `.out` here pulls in all source code of all recursive go
  # dependencies of filebeat.
  # We do this so that filebeat can find `filebeat.template.json`
  # (and other files that for the Debian bindist would be in /etc/filebeat).
  # Unfortunately it's not clear how we can add them to the `buildGoPackage`
  # that creates `pkgs.filebeat`, and it is also not clear how we can
  # determine from the filebeat source code which files we have to copy.
  configDir = "${pkgs.filebeat.out}/share/go/src/github.com/elastic/beats/filebeat";
in
{
  options = {

    services.filebeat = {

      enable = mkEnableOption "filebeat";

      stateDir = mkOption {
        type = types.str;
        default = "/var/lib/filebeat";
        description = "The state directory. filebeat's own logs and other data are stored here.";
      };

      extraConfig = mkOption {
        type = types.lines;
        # TODO: Update this examples, `filebeat.prospectors` has been renamed
        #       to `inputs` in filebeat 6.3, see:
        #       https://discuss.elastic.co/t/filebeat-prospectors-has-been-removed/205563
        default = ''
          filebeat.prospectors:
          - type: log
            enabled: true
            paths:
            - /var/log/*.log
        '';
        description = "Any other configuration options you want to add";
      };

    };
  };

  config = mkIf cfg.enable {

    systemd.services.filebeat = with pkgs; {
      description = "filebeat log shipper";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -p "${cfg.stateDir}"/{data,logs}
        chown nobody:nogroup "${cfg.stateDir}"/{data,logs}
      '';
      serviceConfig = {
        # TODO: Don't run filebeat as root.
        # Right now we do it so that it can read any program's logs.
        # But we might do it in a more restrictive fashion by adding a filebeat
        # user and ACLs for specific log files, e.g. as described here:
        #   https://discuss.elastic.co/t/filebeat-as-a-non-root-user/58946
        # User = "...";
        PermissionsStartOnly = true; # so `preStart` can create the dirs, even when we're not running as root
        ExecStart = ''${pkgs.filebeat}/bin/filebeat -c "${filebeatYml}" -path.data "${cfg.stateDir}/data" -path.logs "${cfg.stateDir}/logs" -path.config "${configDir}"'';
      };
    };
  };
}
