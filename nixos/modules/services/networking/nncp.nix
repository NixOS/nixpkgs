{ config, lib, pkgs, ... }:
with lib;

let
  statefulCfgFile = "/etc/nncp.secrets";
  nixosCfgFile = "/run/nncp.hjson";
  programCfg = config.programs.nncp;
  daemonCfg = config.services.nncp.daemon;
  settingsFormat = pkgs.formats.json { };
  jsonCfgFile = settingsFormat.generate "nncp.json" programCfg.settings;
in {
  options = {
    programs.nncp = {

      enable = mkEnableOption "NNCP (Node to Node copy) utilities";

      group = mkOption {
        type = types.str;
        default = "nncp";
        description = ''
          UNIX group that users must be in to use <literal>nncp</literal>.
        '';
      };

      settings = mkOption {
        type = settingsFormat.type;
        description = ''
          NNCP configuration, see
          <link xlink:href="http://www.nncpgo.org/Configuration.html"/>.
          At runtime these settings will overlay the contents of the file
          <literal>${statefulCfgFile}</literal> and will be symlinked at
          <literal>/etc/nncp.hjson</literal>. If <literal>${statefulCfgFile}</literal>
          does not exist then it will be generated.
          Node keypairs go in <literal>${statefulCfgFile}</literal>, do
          not specify them in <literal>settings</literal> as they will be leaked
          into <literal>/nix/store</literal>!
        '';
        default = { };
      };

    };

    services.nncp = {

      daemon = {
        enable = mkEnableOption ''
          NNCP TCP synronization daemon.
          The daemon will take configuration from
          <xref linkend="opt-programs.nncp.settings"/>
        '';
        user = mkOption {
          type = types.str;
          description = ''
            UNIX user to run the daemon as.
            What permissions the daemon requires depends on
            whether <literal>autotoss</literal> is enabled and which
            commands are enabled for remote execution.
          '';
          default = "nobody";
        };
        extraArgs = mkOption {
          type = with types; listOf str;
          description = "Extra command-line arguments to pass to daemon.";
          default = [ ];
          example = [ "-autotoss" "-bind" "192.168.0.2:5400" ];
        };
      };

    };
  };

  config = mkIf (programCfg.enable or daemonCfg.enable) {

    programs.nncp.settings = {
      spool = mkDefault "/var/spool/nncp";
      log = mkDefault "/var/spool/nncp/log";
    };

    environment = mkIf programCfg.enable {
      systemPackages = [ pkgs.nncp ];
      etc."nncp.hjson".source = nixosCfgFile;
    };

    users.groups.${programCfg.group} = { };
    users.users.${daemonCfg.user} = { };

    systemd.tmpfiles.rules = [
      "d ${programCfg.settings.spool} 0770 root ${programCfg.group}"
      "f ${programCfg.settings.log} 0770 root ${programCfg.group}"
    ];

    system.activationScripts.nncp = ''
      nncp_generate_config() {
        local prev_umask=$(umask)
        umask u=rw
        if [ ! -s "${statefulCfgFile}" ]; then
          echo "generating NNCP keypairs"
          ${pkgs.nncp}/bin/nncp-cfgnew -nocomments \
            | ${pkgs.hjson-go}/bin/hjson-cli -c \
            | ${pkgs.jq}/bin/jq 'del(.spool,.log,.neigh.self.exec)' \
            > "${statefulCfgFile}"
        fi
        # merge configurations
        ${pkgs.jq}/bin/jq --slurp ".[0]*.[1]*{neigh:(.[1].neigh*.[0].neigh)}" \
          "${statefulCfgFile}" "${jsonCfgFile}" \
          > "${nixosCfgFile}"
        chown "root:${programCfg.group}" "${nixosCfgFile}"
        chmod 0440 "${nixosCfgFile}"
        umask $prev_umask
      }
      nncp_generate_config
    '';

    systemd.services."nncp-daemon" = mkIf daemonCfg.enable {
      # TODO: socket activation?
      description = "NNCP TCP syncronization daemon.";
      documentation = [ "http://www.nncpgo.org/nncp_002ddaemon.html" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.nncp}/bin/nncp-daemon -quiet -cfg "${nixosCfgFile}" ${
            lib.strings.escapeShellArgs daemonCfg.extraArgs
          }'';
        User = daemonCfg.user;
        Group = programCfg.group;
      };
    };

  };

}
