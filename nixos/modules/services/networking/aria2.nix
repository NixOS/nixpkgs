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
  '';

in
{
  imports = [
    (mkRemovedOptionModule [ "services" "aria2" "rpcSecret" ] "Use services.aria2.rpcSecretFile instead")
  ];

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
        type = types.path;
        default = downloadDir;
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
      rpcSecretFile = mkOption {
        type = types.path;
        example = "/run/secrets/aria2-rpc-token.txt";
        description = ''
          A file containing the RPC secret authorization token.
          Read https://aria2.github.io/manual/en/html/aria2c.html#rpc-auth to know how this option value is used.
        '';
      };
      extraArguments = mkOption {
        type = types.separatedString " ";
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

    users.users.aria2 = {
      group = "aria2";
      uid = config.ids.uids.aria2;
      description = "aria2 user";
      home = homeDir;
      createHome = false;
    };

    users.groups.aria2.gid = config.ids.gids.aria2;

    systemd.tmpfiles.rules = [
      "d '${homeDir}' 0770 aria2 aria2 - -"
      "d '${config.services.aria2.downloadDir}' 0770 aria2 aria2 - -"
    ];

    systemd.services.aria2 = {
      description = "aria2 Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        if [[ ! -e "${sessionFile}" ]]
        then
          touch "${sessionFile}"
        fi
        cp -f "${settingsFile}" "${settingsDir}/aria2.conf"
        echo "rpc-secret=$(cat "$CREDENTIALS_DIRECTORY/rpcSecretFile")" >> "${settingsDir}/aria2.conf"
      '';

      serviceConfig = {
        Restart = "on-abort";
        ExecStart = "${pkgs.aria2}/bin/aria2c --enable-rpc --conf-path=${settingsDir}/aria2.conf ${config.services.aria2.extraArguments} --save-session=${sessionFile}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        User = "aria2";
        Group = "aria2";
        LoadCredential="rpcSecretFile:${cfg.rpcSecretFile}";
      };
    };
  };
}
