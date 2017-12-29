{ config, lib, pkgs, ... }:

with lib;

let

  setupScript = ''
    ## locks
    mkdir -p -m 0755 /var/lock/uucp
    chown "uucp:uucp" "/var/lock/uucp"
    ## etc
    cp -r ${pkgs.hylafaxp}/share/hylafax/etc/hylafax /etc
    cat ${_pagesizes} - > /etc/hylafax/pagesizes
    chown -R "uucp:uucp" "/etc/hylafax"
    chmod -R 0755 /etc/hylafax
    ## spool
    cp -r ${pkgs.hylafaxp}/share/hylafax/var/spool/hylafax /var/spool
    ${if (config.services.hylafaxp.config != "") then "cat ${_config} - > /var/spool/hylafax/etc/config" else ""}
    ${if (config.services.hylafaxp.hfaxd.hosts != "") then "cat ${_hosts_hfaxd} - > /var/spool/hylafax/etc/hosts.hfaxd" else ""}
    ${if (config.services.hylafaxp.faxDispatch != "") then "cat ${_FaxDispatch} - > /var/spool/hylafax/etc/FaxDispatch" else ""}
    ${pkgs.ghostscript}/bin/gs -q -sDEVICE=tiffg3 -sFONTPATH="${_fontPath}" /var/spool/hylafax/bin/genfontmap.ps > /var/spool/hylafax/etc/Fontmap.HylaFAX 2>/dev/null
    ${if (config.services.hylafaxp.devs!={ "" = ""; }) then (concatStringsSep ";" (zipListsWith (a: b: "cp " + a + " /var/spool/hylafax/etc/config." + b) _configDevs _devs)) else ""}
    chmod 0755 /var/spool/hylafax
    ls -A /var/spool/hylafax/ | grep -v -E 'recvq|log' | ${pkgs.gawk}/bin/awk '{print "/var/spool/hylafax/"$1}' | xargs chmod -R 0755
    chmod 0755 /var/spool/hylafax/{recvq,log} # avoid overriding RecvFileMode and LogFileMode in /var/spool/hylafax/etc/config. See: hylafax-config(4)
    ##
    ## faxsetup mkfifos but it seems the services do it fine on their own.
    ## kept commented out for reference or any future complications.
    #rm -f ${pkgs.hylafaxp}/var/spool/hylafax/FIFO* 2>/dev/null
    #mkfifo -m 0777 ${pkgs.hylafaxp}/var/spool/hylafax/FIFO ${if config.services.hylafaxp.devs != { "" = ""; } then ("${pkgs.hylafaxp}/var/spool/hylafax/FIFO." + (concatStringsSep " ${pkgs.hylafaxp}/var/spool/hylafax/FIFO." _devs)) else ""} 2>/dev/null
    ##
    ${if (config.services.hylafaxp.hfaxd.hosts != "") then "chmod 0600 /var/spool/hylafax/etc/hosts.hfaxd" else ""} #runtime enforced sercurity. see: hfaxd/User.c++:160
    chown -R "uucp:uucp" "/var/spool/hylafax"
  '';
  _fontPath = concatStringsSep " " [
    "${pkgs.ghostscript}/share/ghostscript/fonts"
    "${pkgs.ghostscript}/share/ghostscript/${pkgs.ghostscript.version}/lib"
    "${pkgs.ghostscript}/share/ghostscript/${pkgs.ghostscript.version}/Resource/Init"
    "${pkgs.ghostscript}/share/ghostscript/${pkgs.ghostscript.version}/Resource/Font"
    "${pkgs.ghostscript}/share/fonts/default/ghostscript"
    "${pkgs.ghostscript}/share/fonts/default/Type1"
    "${pkgs.ghostscript}/share/fonts/default/TrueType"
  ];
  _config = pkgs.writeText "config" config.services.hylafaxp.config;
  _hosts_hfaxd = pkgs.writeText "hosts.hfaxd" config.services.hylafaxp.hfaxd.hosts;
  _FaxDispatch = pkgs.writeText "FaxDispatch" config.services.hylafaxp.faxDispatch;
  _pagesizes = pkgs.writeText "pagesizes" config.services.hylafaxp.pagesizes;
  ## list of devs
  _devs = mapAttrsToList (n: v: n) config.services.hylafaxp.devs;
  ## list of per-dev config files
  _configDevs = mapAttrsToList (n: v: pkgs.writeText n v) config.services.hylafaxp.devs;

in
{

  ###### interface

  options = {

    services.hylafaxp.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable HylaFAX+, a Fax Management System.
      '';
    };

    services.hylafaxp.devs = mkOption {
      default = { "" = ""; };
      example = { ttyACM0 = "/var/spool/hylafax/etc/config.ttyACM0 content"; ttyS1 = "/var/spool/hylafax/etc/config.ttyS1 content"; };
      type = types.attrsOf types.lines;
      description = ''
        The ttyFOOBAR devices and their /var/spool/hylafax/etc/config.ttyFOOBAR files.
        Run faxsetup to generate the files interactively.
        Be sure to copy the results to configuration.nix!
      '';
    };

    services.hylafaxp.config = mkOption {
      type = types.lines;
      default = "";
      description = ''
        The content of the /var/spool/hylafax/etc/config file.
        Run faxsetup to generate one interactively.
        Be sure to copy the results to configuration.nix!
      '';
    };

    services.hylafaxp.pagesizes = mkOption {
      type = types.lines;
      default = ''
        #	$Id: pagesizes.in 2 2005-11-11 21:32:03Z faxguy $
        #
        # Warning, /etc/hylafax/pagesizes was automatically created by NixOS.
        #
        # HylaFAX Page Size Database
        #
        # This file defines the set of known page sizes.  Note that the name is
        # matched using a caseless comparison.  Most of the guaranteed reproducible
        # areas are guesses based on scaling known GRA's.
        #
        # File format:
        #
        # 1. Comments are introduced by '#' and continue to the end of line.
        # 2. The first two fields are the full and abbreviated page size names
        #    and must be separated from the subsequent fields by a tab (possibly
        #    followed by more whitespace).  Otherwise fields can be separated
        #    by any amount of any kind of whitespace.
        # 3. Numbers are all base 10 and in basic measurement units (BMU);
        #    defined as 1/1200 x 25.4 mm for paper output with a scale factor
        #    of one.
        # 4. All fields must be present on a single line; otherwise the entry
        #    is ignored.
        # 5. Most all users of this database require a "default" entry that
        #    specifies the default page size to use.  This entry should be placed
        #    last so that inverse matches find the real page size name and not
        #    the default entry.
        #						Guaranteed Reproducible Area
        # Name			Abbrev	Width	Height	Width	Height	Top	Left
        ISO A3			A3	14030	19840	13200	 18480	472	345
        ISO A4			A4	 9920	14030	 9240	 13200	472	345
        ISO A5			A5	 7133	 9921	 6455	  9236	472	345
        ISO A6			A6	 5055	 6991	 4575	  6508	472	345
        ISO B4			B4	12048	17196	11325	 16010	472	345
        North American Letter	NA-LET	10200	13200	 9240	 12400	472	345
        American Legal		US-LEG	10200	16800	 9240	 15775	472	345
        American Ledger		US-LED	13200	20400	11946	 19162	472	345
        American Executive	US-EXE	 8700	12600	 7874	 11835	472	345
        Japanese Letter		JP-LET	 8598	12141	 7600	 10200	900	400
        Japanese Legal		JP-LEG	12141	17196	11200	 15300	900	400
        #
        default			A4	 9920	14030	 9240	 13200	472	345
      '';
      description = ''
        Page sizes as defined in /etc/hylafax/pagesizes.
        Defaults to A4.
      '';
    };

    services.hylafaxp.faxDispatch = mkOption {
      type = types.lines;
      default = "";
      example = ''
        SENDTO=FaxMaster;
        FILETYPE=tif;
      '';
      description = ''
        faxrcvd's facsimile dispatching script at /var/spool/hylafax/etc/FaxDispatch.
      '';
    };

    services.hylafaxp.hfaxd = {
      enable = mkOption {
        type = types.bool;
        default = false ;
        description = ''
          Whether to enable hfaxd, HylaFAX+ client-server protocol server.
        '';
      };
      port = mkOption {
        type = types.int;
        default = 4559 ;
        description = ''
          hfaxd's port.
        '';
      };
      hosts = mkOption {
        type = types.lines;
        default = ''
          localhost
          127.0.0.1
        '';
        description = ''
          The client access control list at /var/spool/hylafax/etc/hosts.hfaxd.
          Run faxadduser to add hosts, users and passwords.
          Be sure to copy the results to configuration.nix!
        '';
      };
    };

  };

  ###### implementation

  config = mkIf config.services.hylafaxp.enable {
    environment.systemPackages = with pkgs; [ hylafaxp ];

    users.extraUsers = [
      {
        name = "uucp";
        uid = config.ids.uids.uucp;
        group = "uucp";
      }
    ];

    # the services refork as uucp on their own
    systemd = mkMerge [
      ({
        targets.hylafaxp = {
          description = "HylaFAX+ Server";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
        };
      })
      (mkIf (config.services.hylafaxp.devs!={ "" = ""; } && _devs!="") {
        services = let
          mkFaxgettyService = dev:
          nameValuePair "hylafaxp-faxgetty-${dev}" {
            description = "faxgetty ${dev}: HylaFAX+ front-door process";
            after = [ "hylafaxp-setup.service" "hylafaxp-faxq.service" "${dev}.device" ];
            before = optional config.services.hylafaxp.hfaxd.enable "hylafaxp-hfaxd.service";
            wantedBy = [ "${dev}.device" ];
            requiredBy = [ "hylafaxp.target" ];
            partOf = [ "hylafaxp.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.hylafaxp}/bin/faxgetty -D -q /var/spool/hylafax ${dev}";
              ExecStop = "${pkgs.hylafaxp}/bin/faxquit -q /var/spool/hylafax ${dev}";
              KillSignal = "SIGHUP"; # gives faxquit a chance
              User = "root";
              Group = "root";
              Restart = "always";
              RestartSec = 3; # hardware tty devices can be slow to respond
              Type = "forking";
            };
          };
        in listToAttrs (map mkFaxgettyService _devs) // { };
      })
      ({
        services = {
          "hylafaxp-faxq" = {
            description = "faxq: HylaFAX+ queue manager process";
            before = optional config.services.hylafaxp.hfaxd.enable "hylafaxp-hfaxd.service";
            after = [ "hylafaxp-setup.service" ];
            requiredBy = [ "hylafaxp.target" ];
            partOf = [ "hylafaxp.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.hylafaxp}/bin/faxq -q /var/spool/hylafax";
              ExecStop = "${pkgs.hylafaxp}/bin/faxquit -q /var/spool/hylafax";
              KillSignal = "SIGHUP"; # gives faxquit a chance
              User = "root";
              Group = "root";
              Restart = "always";
              RestartSec = 1;
              Type = "forking";
            };
          };
          "hylafaxp-hfaxd" = mkIf config.services.hylafaxp.hfaxd.enable {
            description = "hfaxd: HylaFAX+ client-server protocol server";
            after = [ "hylafaxp-setup.service" "hylafaxp-faxq.service" ];
            requiredBy = [ "hylafaxp.target" ];
            partOf = [ "hylafaxp.target" ];
            serviceConfig = {
              ExecStart = "${pkgs.hylafaxp}/bin/hfaxd -i ${toString config.services.hylafaxp.hfaxd.port} -q /var/spool/hylafax";
              User = "root";
              Group = "root";
              Restart = "always";
              RestartSec = 1;
              Type = "forking";
            };
          };
          "hylafaxp-setup" = {
            description = "HylaFAX+ Setup Task";
            requiredBy = [ "hylafaxp.target" ];
            partOf = [ "hylafaxp.target" ];
            script = setupScript;
            serviceConfig = {
              Type = "oneshot";
            };
          };
        };
      })
    ];
  };
}
