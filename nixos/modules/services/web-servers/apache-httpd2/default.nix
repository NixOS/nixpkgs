{ pkgs, config, lib, options, ... }:
with lib;
let
  cfg = config.services.httpd2;
  pkg = cfg.package.out;

  # This stuff is included externally, because Magic_RB wanted to use those functions in his own projects without
  # maintaining two separate copies. Please add anything which doesn't interact with the NixOS module system here,
  # thanks! :)
  inherit (import ./separate.nix { inherit lib; }) runtimeDir configParser;
in
{
  options = {
    services.httpd2 = {
      enable = mkEnableOption "Enable Apache2 http server";

      package = mkOption {
        type = types.package;
        default = pkgs.apacheHttpd;
        defaultText = "pkgs.apacheHttpd";
        description = ''
          Overridable attribute of the Apache HTTP Server package to use.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "wwwrun";
        description = ''
          User account under which httpd children processes run.
          If you require the main httpd process to run as
          <literal>root</literal> add the following configuration:
          <programlisting>
          systemd.services.httpd.serviceConfig.User = lib.mkForce "root";
          </programlisting>
        '';
      };

      group = mkOption {
        type = types.str;
        default = "wwwrun";
        description = ''
          Group under which httpd children processes run.
        '';
      };

      configuration = mkOption {
        description = "Apache2 configuration";
        type = with types;
          let
            self =
              oneOf [
                (attrsOf (oneOf [
                  str
                  int
                  (listOf (oneOf [ str int (listOf (oneOf [ str int ])) ]))
                  (attrsOf self)
                ]))
                (listOf (oneOf [ str self]))
              ];
          in
            self // { description = "loop breaker"; };
      };
    };
  };

  config =
    let
      httpdConf = pkgs.writeText "apache.cfg" (configParser cfg.configuration);
    in
      (mkIf cfg.enable {
        users.users = optionalAttrs (cfg.user == "wwwrun") {
          wwwrun = {
            group = cfg.group;
            description = "Apache httpd user";
            uid = config.ids.uids.wwwrun;
          };
        };

        users.groups = optionalAttrs (cfg.group == "wwwrun") {
          wwwrun.gid = config.ids.gids.wwwrun;
        };

        systemd.services.httpd2 = {
          description = "Apache HTTPD";
          wantedBy = [ "multi-user.target" ];
          # wants = concatLists (map (certName: [ "acme-finished-${certName}.target" ]) dependentCertNames);
          after = [ "network.target" ]; # ++ map (certName: "acme-selfsigned-${certName}.service") dependentCertNames;
          # before = map (certName: "acme-${certName}.service") dependentCertNames;

          path = [ pkg pkgs.coreutils pkgs.gnugrep ];

          # environment =
          #   optionalAttrs cfg.enablePHP { PHPRC = phpIni; }
          #   // optionalAttrs cfg.enableMellon { LD_LIBRARY_PATH  = "${pkgs.xmlsec}/lib"; };

          preStart =
            ''
                # Get rid of old semaphores.  These tend to accumulate across
                # server restarts, eventually preventing it from restarting
                # successfully.
                for i in $(${pkgs.util-linux}/bin/ipcs -s | grep ' ${cfg.user} ' | cut -f2 -d ' '); do
                  ${pkgs.util-linux}/bin/ipcrm -s $i
                done
            '';

          serviceConfig = {
            ExecStart = "${pkg}/bin/httpd -f ${httpdConf}";
            ExecStop = "${pkg}/bin/httpd -f ${httpdConf} -k graceful-stop";
            ExecReload = "${pkg}/bin/httpd -f ${httpdConf} -k graceful";
            User = cfg.user;
            Group = cfg.group;
            Type = "forking";
            PIDFile = "${runtimeDir}/httpd.pid";
            Restart = "always";
            RestartSec = "5s";
            RuntimeDirectory = "httpd httpd/runtime";
            RuntimeDirectoryMode = "0750";
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          };
        };
      });
}
