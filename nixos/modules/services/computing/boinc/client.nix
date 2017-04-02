{config, lib, pkgs, ...}:

with lib;

let
  cfg = config.services.boinc;
  allowRemoteGuiRpcFlag = optionalString cfg.allowRemoteGuiRpc "--allow_remote_gui_rpc";

in
  {
    options.services.boinc = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the BOINC distributed computing client. If this
          option is set to true, the boinc_client daemon will be run as a
          background service. The boinccmd command can be used to control the
          daemon.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.boinc;
        defaultText = "pkgs.boinc";
        description = ''
          Which BOINC package to use.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/boinc";
        description = ''
          The directory in which to store BOINC's configuration and data files.
        '';
      };

      allowRemoteGuiRpc = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If set to true, any remote host can connect to and control this BOINC
          client (subject to password authentication). If instead set to false,
          only the hosts listed in <varname>dataDir</varname>/remote_hosts.cfg will be allowed to
          connect.

          See also: <link xlink:href="http://boinc.berkeley.edu/wiki/Controlling_BOINC_remotely#Remote_access"/>
        '';
      };
    };

    config = mkIf cfg.enable {
      environment.systemPackages = [cfg.package];

      users.users.boinc = {
        createHome = false;
        description = "BOINC Client";
        home = cfg.dataDir;
        isSystemUser = true;
      };

      systemd.services.boinc = {
        description = "BOINC Client";
        after = ["network.target" "local-fs.target"];
        wantedBy = ["multi-user.target"];
        preStart = ''
          mkdir -p ${cfg.dataDir}
          chown boinc ${cfg.dataDir}
        '';
        script = ''
          ${cfg.package}/bin/boinc_client --dir ${cfg.dataDir} --redirectio ${allowRemoteGuiRpcFlag}
        '';
        serviceConfig = {
          PermissionsStartOnly = true; # preStart must be run as root
          User = "boinc";
          Nice = 10;
        };
      };
    };

    meta = {
      maintainers = with lib.maintainers; [kierdavis];
    };
  }
