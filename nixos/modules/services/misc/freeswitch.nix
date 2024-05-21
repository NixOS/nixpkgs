{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.freeswitch;
  pkg = cfg.package;
  configDirectory = pkgs.runCommand "freeswitch-config-d" { } ''
    mkdir -p $out
    cp -rT ${cfg.configTemplate} $out
    chmod -R +w $out
    ${concatStringsSep "\n" (mapAttrsToList (fileName: filePath: ''
      mkdir -p $out/$(dirname ${fileName})
      cp ${filePath} $out/${fileName}
    '') cfg.configDir)}
  '';
  configPath = if cfg.enableReload
    then "/etc/freeswitch"
    else configDirectory;
in {
  options = {
    services.freeswitch = {
      enable = mkEnableOption "FreeSWITCH";
      enableReload = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Issue the `reloadxml` command to FreeSWITCH when configuration directory changes (instead of restart).
          See [FreeSWITCH documentation](https://freeswitch.org/confluence/display/FREESWITCH/Reloading) for more info.
          The configuration directory is exposed at {file}`/etc/freeswitch`.
          See also `systemd.services.*.restartIfChanged`.
        '';
      };
      configTemplate = mkOption {
        type = types.path;
        default = "${config.services.freeswitch.package}/share/freeswitch/conf/vanilla";
        defaultText = literalExpression ''"''${config.services.freeswitch.package}/share/freeswitch/conf/vanilla"'';
        example = literalExpression ''"''${config.services.freeswitch.package}/share/freeswitch/conf/minimal"'';
        description = ''
          Configuration template to use.
          See available templates in [FreeSWITCH repository](https://github.com/signalwire/freeswitch/tree/master/conf).
          You can also set your own configuration directory.
        '';
      };
      configDir = mkOption {
        type = with types; attrsOf path;
        default = { };
        example = literalExpression ''
          {
            "freeswitch.xml" = ./freeswitch.xml;
            "dialplan/default.xml" = pkgs.writeText "dialplan-default.xml" '''
              [xml lines]
            ''';
          }
        '';
        description = ''
          Override file in FreeSWITCH config template directory.
          Each top-level attribute denotes a file path in the configuration directory, its value is the file path.
          See [FreeSWITCH documentation](https://freeswitch.org/confluence/display/FREESWITCH/Default+Configuration) for more info.
          Also check available templates in [FreeSWITCH repository](https://github.com/signalwire/freeswitch/tree/master/conf).
        '';
      };
      package = mkPackageOption pkgs "freeswitch" { };
    };
  };
  config = mkIf cfg.enable {
    environment.etc.freeswitch = mkIf cfg.enableReload {
      source = configDirectory;
    };
    systemd.services.freeswitch-config-reload = mkIf cfg.enableReload {
      before = [ "freeswitch.service" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configDirectory ];
      serviceConfig = {
        ExecStart = "/run/current-system/systemd/bin/systemctl try-reload-or-restart freeswitch.service";
        RemainAfterExit = true;
        Type = "oneshot";
      };
    };
    systemd.services.freeswitch = {
      description = "Free and open-source application server for real-time communication";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        StateDirectory = "freeswitch";
        ExecStart = "${pkg}/bin/freeswitch -nf \\
          -mod ${pkg}/lib/freeswitch/mod \\
          -conf ${configPath} \\
          -base /var/lib/freeswitch";
        ExecReload = "${pkg}/bin/fs_cli -x reloadxml";
        Restart = "on-failure";
        RestartSec = "5s";
        CPUSchedulingPolicy = "fifo";
      };
    };
    environment.systemPackages = [ pkg ];
  };
}
