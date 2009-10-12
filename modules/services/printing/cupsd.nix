{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) cups;

  logDir = "/var/log/cups";

  modprobe = config.system.sbin.modprobe;

  cfg = config.services.printing;

  # Here we can enable additional backends, filters, etc. that are not
  # part of CUPS itself, e.g. the SMB backend is part of Samba.  Since
  # we can't update ${cups}/lib/cups itself, we create a symlink tree
  # here and add the additional programs.  The ServerBin directive in
  # cupsd.conf tells cupsd to use this tree.
  bindir = pkgs.runCommand "cups-progs" {}
    ''
      ensureDir $out/lib/cups
      ln -s ${cups}/lib/cups/* $out/lib/cups/

      # Provide support for printing via SMB.    
      rm $out/lib/cups/backend
      ensureDir $out/lib/cups/backend
      ln -s ${cups}/lib/cups/backend/* $out/lib/cups/backend/
      ln -s ${pkgs.samba}/bin/smbspool $out/lib/cups/backend/smb

      # Provide support for printing via HTTPS.
      ln -s ipp $out/lib/cups/backend/https

      # Provide Ghostscript rasterisation, necessary for non-Postscript
      # printers.
      rm $out/lib/cups/filter
      ensureDir $out/lib/cups/filter
      ln -s ${cups}/lib/cups/filter/* $out/lib/cups/filter/
      ln -s ${pkgs.ghostscript}/lib/cups/filter/* $out/lib/cups/filter/
      ${cfg.bindirCmds}
    ''; # */
  

  cupsdConfig = pkgs.writeText "cupsd.conf"
    ''
      LogLevel debug

      SystemGroup root

      Listen localhost:631
      Listen /var/run/cups/cups.sock

      # Note: we can't use ${cups}/etc/cups as the ServerRoot, since
      # CUPS will write in the ServerRoot when e.g. adding new printers
      # through the web interface.
      ServerRoot /etc/cups

      ServerBin ${bindir}/lib/cups

      AccessLog ${logDir}/access_log
      ErrorLog ${logDir}/access_log
      PageLog ${logDir}/page_log

      TempDir /tmp

      Browsing On
      BrowseOrder allow,deny
      BrowseAllow @LOCAL

      DefaultAuthType Basic

      <Location />
        Order allow,deny
        Allow localhost
      </Location>

      <Location /admin>
        Order allow,deny
        Allow localhost
      </Location>

      <Location /admin/conf>
        AuthType Basic
        Require user @SYSTEM
        Order allow,deny
        Allow localhost
      </Location>

      <Policy default>
        <Limit Send-Document Send-URI Hold-Job Release-Job Restart-Job Purge-Jobs Set-Job-Attributes Create-Job-Subscription Renew-Subscription Cancel-Subscription Get-Notifications Reprocess-Job Cancel-Current-Job Suspend-Current-Job Resume-Job CUPS-Move-Job>
          Require user @OWNER @SYSTEM
          Order deny,allow
        </Limit>

        <Limit Pause-Printer Resume-Printer Set-Printer-Attributes Enable-Printer Disable-Printer Pause-Printer-After-Current-Job Hold-New-Jobs Release-Held-New-Jobs Deactivate-Printer Activate-Printer Restart-Printer Shutdown-Printer Startup-Printer Promote-Job Schedule-Job-After CUPS-Add-Printer CUPS-Delete-Printer CUPS-Add-Class CUPS-Delete-Class CUPS-Accept-Jobs CUPS-Reject-Jobs CUPS-Set-Default>
          AuthType Basic
          Require user @SYSTEM
          Order deny,allow
        </Limit>

        <Limit Cancel-Job CUPS-Authenticate-Job>
          Require user @OWNER @SYSTEM
          Order deny,allow
        </Limit>

        <Limit All>
          Order deny,allow
        </Limit>
      </Policy>
    '';

in

{

  ###### interface

  options = {
  
    services.printing = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable printing support through the CUPS daemon.
        '';
      };

      bindirCmds = mkOption {
        default = "";
        description = ''
          Additional commands executed while creating the directory
          containing the CUPS server binaries.
        '';
      };

    };

  };

    
  ###### implementation

  config = mkIf config.services.printing.enable {

    environment.systemPackages = [cups];

    environment.etc =
      [ # CUPS expects the following files in its ServerRoot.
        { source = "${cups}/etc/cups/mime.convs";
          target = "cups/mime.convs";
        }
        { source = "${cups}/etc/cups/mime.types";
          target = "cups/mime.types";
        }
      ];

    jobAttrs.cupsd =
      { description = "CUPS printing daemon";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        preStart =
          ''
            mkdir -m 0755 -p ${logDir}
            mkdir -m 0700 -p /var/cache/cups
            mkdir -m 0700 -p /var/spool/cups

            # Make USB printers show up.
            ${modprobe}/sbin/modprobe usblp || true
          '';

        exec = "${cups}/sbin/cupsd -c ${cupsdConfig} -F";
      };

  };
  
}
