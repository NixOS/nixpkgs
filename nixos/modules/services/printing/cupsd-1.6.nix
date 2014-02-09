{ config, pkgs, ... }:

/* Major changes compared to 1.5.4:
   cups.conf has been split into cups.conf and cups-files.conf
   See conf.c

   Default filter chain is PDF ? when did this change happen?

  filters have been split into extra package => cupsFilters.
  They build but cause collisions

  TODO: 
    I've moved all settings to cups-files.conf but didn't check which new
    options exist and should be set.

    Adding USB printers only works when allowing access to the USB device:

    chmod 777 /dev/bus/usb/002/003  The 002 003 numbers can be determined by
    lsusb easily

    Printing the CUPS test page doesn't work yet (fix filters, in which way?)

  Note: 1.7 does only contain small changes such as compressing print files
  when sending them over the network - so probably upgrading version
  will just work
*/

with pkgs.lib;

let

  cfg = config.services.printing;

  inherit (cfg) cupsPackages;

  gutenprintPackageList = optional (cfg.gutenprintPackage != null) cfg.gutenprintPackage;

  additionalBackends = pkgs.runCommand "additional-cups-backends" { }
    ''
      mkdir -p $out
      if [ ! -e ${cupsPackages.cups}/lib/cups/backend/smb ]; then
        mkdir -p $out/lib/cups/backend
        ln -sv ${cupsPackages.samba}/bin/smbspool $out/lib/cups/backend/smb
      fi

      # Provide support for printing via HTTPS.
      if [ ! -e ${cupsPackages.cups}/lib/cups/backend/https ]; then
        mkdir -p $out/lib/cups/backend
        ln -sv ${cupsPackages.cups}/lib/cups/backend/ipp $out/lib/cups/backend/https
      fi

      # Import filter configuration from Ghostscript.
      mkdir -p $out/share/cups/mime/
      ln -v -s "${cupsPackages.ghostscript}/etc/cups/"* $out/share/cups/mime/
    '';

  # Here we can enable additional backends, filters, etc. that are not
  # part of CUPS itself, e.g. the SMB backend is part of Samba.  Since
  # we can't update ${cups}/lib/cups itself, we create a symlink tree
  # here and add the additional programs.  The ServerBin directive in
  # cupsd.conf tells cupsd to use this tree.
  bindir = pkgs.buildEnv {
    name = "cups-progs";
    paths = cfg.drivers;
    pathsToLink = [ "/lib/cups" "/share/cups" "/bin" ];
    postBuild = cfg.bindirCmds;
    ignoreCollisions = true;
  };

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

      cupsdConf = mkOption {
        default = "";
        example =
          ''
            BrowsePoll cups.example.com
            LogLevel debug
          '';
        description = ''
          The contents of the configuration file of the CUPS daemon
          (<filename>cupsd.conf</filename>).
        '';
      };

      cupsFilesConf = mkOption {
        default = "";
        example =
          ''
          ServerRoot /etc/cups
          '';
        description = ''
          The contents of the configuration file of the CUPS daemon
          (<filename>cups-files.conf</filename>).
        '';
      };

      gutenprintPackage = mkOption {
        default = null;
        description = ''
          Enable gutenprint by setting this options to config.services.printing.cupsPackages.gutenprint(CVS).
          Unless this setting is null (default) gutenprint.ppds will be symlinked to /run/current-system/sw/ppds/.
          When installing a new printer in cupsd web interface select the matching ppd file.
        '';
      };

      cupsPackages = mkOption {
        # cups is a dependency of quite a lot of packages, same applies to ghostscript
        # So it might be a good idea to allow overriding anything easily
        default =
          let cups = pkgs.cups.override { version = "1.7.x"; }; in

          # include this cups
          { inherit cups; }

          # and important packages and force version of cups, ghostscript in
          # the dependency chain
          // (mapAttrs (name: value: value.deepOverride {
               inherit cups;
               ghostscript = pkgs.ghostscriptMainline_9_10;
             }) { inherit (pkgs) cupsFilters cups_pdf_filter samba splix ghostscript gutenprint gutenprintCVS; });

        description = ''
          A attrset containing all cups related derivations to be used to build
          up this service.
        '';
      };

      drivers = mkOption {
        example = [ config.services.printing.cupsPackages.splix ];
        description = ''
          CUPS drivers (CUPS, gs and samba are added unconditionally).
          gutenprint see <option>gutenprintPackage</option>
        '';
      };

      tempDir = mkOption {
        default = "/tmp";
        example = "/tmp/cups";
        description = ''
          CUPSd temporary directory.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.printing.enable {

    users.extraUsers = singleton
      { name = "cups";
        uid = config.ids.uids.cups;
        group = "lp";
        description = "CUPS printing services";
      };

    environment.systemPackages = [ cupsPackages.cups ] ++ gutenprintPackageList;

    services.dbus.packages = [ cupsPackages.cups ];

    # Cups uses libusb to talk to printers, and does not use the
    # linux kernel driver. If the driver is not in a black list, it
    # gets loaded, and then cups cannot access the printers.
    boot.blacklistedKernelModules = [ "usblp" ];

    systemd.services.cupsd =
      { description = "CUPS Printing Daemon";

        wantedBy = [ "multi-user.target" ];
        after = [ "network-interfaces.target" ];

        path = [ cupsPackages.cups ];

        preStart =
          ''
            mkdir -m 0755 -p /etc/cups
            mkdir -m 0700 -p /var/cache/cups
            mkdir -m 0700 -p /var/spool/cups
            mkdir -m 0755 -p ${cfg.tempDir}
          '';

        # serviceConfig.Type = "forking";
        serviceConfig.ExecStart = 
          let cupsdConf = pkgs.writeText "cupsd.conf" cfg.cupsdConf;
              cupsFilesConf = pkgs.writeText "cups-files.conf" cfg.cupsFilesConf;
          in "@${cupsPackages.cups}/sbin/cupsd cupsd -f -c ${cupsdConf} -s ${cupsFilesConf}";
      };

    services.printing.drivers =
      [ cupsPackages.cups
        cupsPackages.cupsFilters
        # cupsPackages.cups_pdf_filter # does not compile ..
        cupsPackages.ghostscript additionalBackends pkgs.perl pkgs.coreutils pkgs.gnused
      ] ++ gutenprintPackageList;

    services.printing.cupsFilesConf =
      ''
        SystemGroup root

        # Note: we can't use ${cupsPackages.cups}/etc/cups as the ServerRoot, since
        # CUPS will write in the ServerRoot when e.g. adding new printers
        # through the web interface.
        ServerRoot /etc/cups

        ServerBin ${bindir}/lib/cups
        DataDir ${bindir}/share/cups

        AccessLog syslog
        ErrorLog syslog
        PageLog syslog

        TempDir ${cfg.tempDir}

        # User and group used to run external programs, including
        # those that actually send the job to the printer.  Note that
        # Udev sets the group of printer devices to `lp', so we want
        # these programs to run as `lp' as well.
        User cups
        Group lp
      '';

    # Set LogLevel to debug2 to get most useful information
    services.printing.cupsdConf =
      ''
        # See AccessLog in cups-files.conf
        LogLevel debug3

        Listen localhost:631
        Listen /var/run/cups/cups.sock

        SetEnv PATH ${bindir}/lib/cups/filter:${bindir}/bin:${bindir}/sbin

        AccessLogLevel all


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

    # Allow CUPS to receive IPP printer announcements via UDP.
    networking.firewall.allowedUDPPorts = [ 631 ];

  };
}
