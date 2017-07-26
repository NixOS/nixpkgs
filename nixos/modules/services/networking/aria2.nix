{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.aria2;

  homeDir = "/var/lib/aria2";

  settingsDir = "${homeDir}";
  sessionFile = "${homeDir}/aria2.session";
  downloadDir = "${homeDir}/Downloads";
  
  rangesToStringList = map (x: builtins.toString x.from +"-"+ builtins.toString x.to);
  
  settingsFile = pkgs.writeText "aria2.conf"
  ''
    dir=${cfg.downloadDir}
    listen-port=${concatStringsSep "," (rangesToStringList cfg.listenPortRange)}
    rpc-listen-port=${toString cfg.rpcListenPort}
    rpc-secret=${cfg.rpcSecret}
  '';

in
{
  options = {
    services.aria2 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether or not to enable the headless Aria2 daemon service.

          Aria2 daemon can be controlled via the RPC interface using
          one of many WebUI (http://localhost:6800/ by default).

          Targets are downloaded to ${downloadDir} by default and are
          accessible to users in the "aria2" group.
        '';
      };
      openPorts = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open listen and RPC ports found in listenPortRange and rpcListenPort
          options in the firewall.
        '';
      };
      downloadDir = mkOption {
        type = types.string;
        default = "${downloadDir}";
        description = ''
          Directory to store downloaded files.
        '';
      };
      listenPortRange = mkOption {
        type = types.listOf types.attrs;
        default = [ { from = 6881; to = 6999; } ];
        description = ''
          Set UDP listening port range used by DHT(IPv4, IPv6) and UDP tracker.
        '';
      };
      rpcListenPort = mkOption {
        type = types.int;
        default = 6800;
        description = "Specify a port number for JSON-RPC/XML-RPC server to listen to. Possible Values: 1024-65535";
      };
      rpcSecret = mkOption {
        type = types.string;
        default = "aria2rpc";
        description = ''
          Set RPC secret authorization token.
          Read https://aria2.github.io/manual/en/html/aria2c.html#rpc-auth to know how this option value is used.
        '';
      };
      extraArguments = mkOption {
        type = types.string;
        example = "--rpc-listen-all --remote-time=true";
        default = "";
        description = ''
          Additional arguments to be passed to Aria2.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    # Need to open ports for proper functioning
    networking.firewall = mkIf cfg.openPorts {
      allowedUDPPortRanges = config.services.aria2.listenPortRange;
      allowedTCPPorts = [ config.services.aria2.rpcListenPort ];
    };

    users.extraUsers.aria2 = {
      group = "aria2";
      uid = config.ids.uids.aria2;
      description = "aria2 user";
      home = homeDir;
      createHome = false;
    };

    users.extraGroups.aria2.gid = config.ids.gids.aria2;

    systemd.services.aria2 = {
      description = "aria2 Service";
      after = [ "local-fs.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0770 -p "${homeDir}"
        chown aria2:aria2 "${homeDir}"
        if [[ ! -d "${config.services.aria2.downloadDir}" ]]
        then 
          mkdir -m 0770 -p "${config.services.aria2.downloadDir}"
          chown aria2:aria2 "${config.services.aria2.downloadDir}"
        fi
        if [[ ! -e "${sessionFile}" ]]
        then 
          touch "${sessionFile}"
          chown aria2:aria2 "${sessionFile}"
        fi
        cp -f "${settingsFile}" "${settingsDir}/aria2.conf"
      '';

      serviceConfig = {
        Restart = "on-abort";
        ExecStart = "${pkgs.aria2}/bin/aria2c --enable-rpc --conf-path=${settingsDir}/aria2.conf ${config.services.aria2.extraArguments} --save-session=${sessionFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "aria2";
        Group = "aria2";
        PermissionsStartOnly = true;
      };
    };
  };
}