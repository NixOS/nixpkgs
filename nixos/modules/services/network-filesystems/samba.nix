{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.samba;

  settingsFormat = pkgs.formats.ini { };
  configFile = settingsFormat.generate "smb.conf" cfg.settings;

  samba = cfg.package;

  # This may include nss_ldap, needed for samba if it has to use ldap.
  nssModulesPath = config.system.nssModules.path;

  daemonService = appName: args:
    { description = "Samba Service Daemon ${appName}";
      documentation = [ "man:${appName}(8)" "man:samba(7)" "man:smb.conf(5)" ];

      after = [ (mkIf (cfg.nmbd.enable && "${appName}" == "smbd") "samba-nmbd.service") "network.target" ];
      requiredBy = [ "samba.target" ];
      partOf = [ "samba.target" ];

      environment = {
        LD_LIBRARY_PATH = nssModulesPath;
        LOCALE_ARCHIVE = "/run/current-system/sw/lib/locale/locale-archive";
      };

      serviceConfig = {
        ExecStart = "${samba}/sbin/${appName} --foreground --no-process-group ${args}";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        LimitNOFILE = 16384;
        PIDFile = "/run/${appName}.pid";
        Type = "notify";
        NotifyAccess = "all"; #may not do anything...
        Slice = "system-samba.slice";
      };
      unitConfig.RequiresMountsFor = "/var/lib/samba";

      restartTriggers = [ configFile ];
    };

in

{
  meta = {
    doc = ./samba.md;
    maintainers = [ lib.maintainers.anthonyroussel ];
  };

  imports = [
    (mkRemovedOptionModule [ "services" "samba" "defaultShare" ] "")
    (mkRemovedOptionModule [ "services" "samba" "syncPasswordsByPam" ] "This option has been removed by upstream, see https://bugzilla.samba.org/show_bug.cgi?id=10669#c10")

    (lib.mkRemovedOptionModule [ "services" "samba" "configText" ] ''
      Use services.samba.settings instead.

      This is part of the general move to use structured settings instead of raw
      text for config as introduced by RFC0042:
      https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md
    '')
    (lib.mkRemovedOptionModule [ "services" "samba" "extraConfig" ] "Use services.samba.settings instead.")
    (lib.mkRenamedOptionModule [ "services" "samba" "invalidUsers" ] [ "services" "samba" "settings" "global" "invalid users" ])
    (lib.mkRenamedOptionModule [ "services" "samba" "securityType" ] [ "services" "samba" "settings" "global" "security type" ])
    (lib.mkRenamedOptionModule [ "services" "samba" "shares" ] [ "services" "samba" "settings" ])

    (lib.mkRenamedOptionModule [ "services" "samba" "enableWinbindd" ] [ "services" "samba" "winbindd" "enable" ])
    (lib.mkRenamedOptionModule [ "services" "samba" "enableNmbd" ] [ "services" "samba" "nmbd" "enable" ])
  ];

  ###### interface

  options = {

    # !!! clean up the descriptions.

    services.samba = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Samba, which provides file and print
          services to Windows clients through the SMB/CIFS protocol.

          ::: {.note}
          If you use the firewall consider adding the following:

              services.samba.openFirewall = true;
          :::
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to automatically open the necessary ports in the firewall.
        '';
      };

      smbd.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc "Whether to enable Samba's smbd daemon.";
      };

      nmbd.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable Samba's nmbd, which replies to NetBIOS over IP name
          service requests. It also participates in the browsing protocols
          which make up the Windows "Network Neighborhood" view.
        '';
      };

      winbindd.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable Samba's winbindd, which provides a number of services
          to the Name Service Switch capability found in most modern C libraries,
          to arbitrary applications via PAM and ntlm_auth and to Samba itself.
        '';
      };

      package = mkPackageOption pkgs "samba" {
        example = "samba4Full";
      };

      nsswins = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to enable the WINS NSS (Name Service Switch) plug-in.
          Enabling it allows applications to resolve WINS/NetBIOS names (a.k.a.
          Windows machine names) by transparently querying the winbindd daemon.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule { freeformType = settingsFormat.type; };
        default = {};
        example = {
          "global" = {
            "security" = "user";
            "passwd program" = "/run/wrappers/bin/passwd %u";
            "invalid users" = "root";
          };
          "public" = {
            "path" = "/srv/public";
            "read only" = "yes";
            "browseable" = "yes";
            "guest ok" = "yes";
            "comment" = "Public samba share.";
          };
        };
        description = ''
          Configuration file for the Samba suite in ini format.
          This file is located in /etc/samba/smb.conf

          Refer to <https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html>
          for all available options.
        '';
      };
    };

  };


  ###### implementation

  config = mkMerge
    [ { assertions =
          [ { assertion = cfg.nsswins -> cfg.winbindd.enable;
              message   = "If services.samba.nsswins is enabled, then services.samba.winbindd.enable must also be enabled";
            }
          ];
      }

      (mkIf cfg.enable {
        environment.etc."samba/smb.conf".source = configFile;

        system.nssModules = optional cfg.nsswins samba;
        system.nssDatabases.hosts = optional cfg.nsswins "wins";

        systemd = {
          targets.samba = {
            description = "Samba Server";
            after = [ "network.target" ];
            wants = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];
          };

          slices.system-samba = {
            description = "Samba slice";
          };

          # Refer to https://github.com/samba-team/samba/tree/master/packaging/systemd
          # for correct use with systemd
          services = {
            samba-smbd = mkIf cfg.smbd.enable (daemonService "smbd" "");
            samba-nmbd = mkIf cfg.nmbd.enable (daemonService "nmbd" "");
            samba-winbindd = mkIf cfg.winbindd.enable (daemonService "winbindd" "");
          };
          tmpfiles.rules = [
            "d /var/lock/samba - - - - -"
            "d /var/log/samba - - - - -"
            "d /var/cache/samba - - - - -"
            "d /var/lib/samba/private - - - - -"
          ];
        };

        security.pam.services.samba = {};
        environment.systemPackages = [ cfg.package ];
        # Like other mount* related commands that need the setuid bit, this is
        # required too.
        security.wrappers."mount.cifs" = {
          program = "mount.cifs";
          source = "${lib.getBin pkgs.cifs-utils}/bin/mount.cifs";
          owner = "root";
          group = "root";
          setuid = true;
        };

        networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ 139 445 ];
        networking.firewall.allowedUDPPorts = mkIf cfg.openFirewall [ 137 138 ];
      })
    ];

}
