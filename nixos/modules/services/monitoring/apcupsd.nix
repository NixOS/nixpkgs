{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.apcupsd;

  configFile = pkgs.writeText "apcupsd.conf" ''
    ## apcupsd.conf v1.1 ##
    # apcupsd complains if the first line is not like above.
    ${cfg.configText}
    SCRIPTDIR ${toString scriptDir}
  '';

  # List of events from "man apccontrol"
  eventList = [
    "annoyme"
    "battattach"
    "battdetach"
    "changeme"
    "commfailure"
    "commok"
    "doreboot"
    "doshutdown"
    "emergency"
    "failing"
    "killpower"
    "loadlimit"
    "mainsback"
    "onbattery"
    "offbattery"
    "powerout"
    "remotedown"
    "runlimit"
    "timeout"
    "startselftest"
    "endselftest"
  ];

  shellCmdsForEventScript = eventname: commands: ''
    echo "#!${pkgs.runtimeShell}" > "$out/${eventname}"
    echo '${commands}' >> "$out/${eventname}"
    chmod a+x "$out/${eventname}"
  '';

  eventToShellCmds = event: if builtins.hasAttr event cfg.hooks then (shellCmdsForEventScript event (builtins.getAttr event cfg.hooks)) else "";

  scriptDir = pkgs.runCommand "apcupsd-scriptdir" { preferLocalBuild = true; } (''
    mkdir "$out"
    # Copy SCRIPTDIR from apcupsd package
    cp -r ${pkgs.apcupsd}/etc/apcupsd/* "$out"/
    # Make the files writeable (nix will unset the write bits afterwards)
    chmod u+w "$out"/*
    # Remove the sample event notification scripts, because they don't work
    # anyways (they try to send mail to "root" with the "mail" command)
    (cd "$out" && rm changeme commok commfailure onbattery offbattery)
    # Remove the sample apcupsd.conf file (we're generating our own)
    rm "$out/apcupsd.conf"
    # Set the SCRIPTDIR= line in apccontrol to the dir we're creating now
    sed -i -e "s|^SCRIPTDIR=.*|SCRIPTDIR=$out|" "$out/apccontrol"
    '' + concatStringsSep "\n" (map eventToShellCmds eventList)

  );

in

{

  ###### interface

  options = {

    services.apcupsd = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Whether to enable the APC UPS daemon. apcupsd monitors your UPS and
          permits orderly shutdown of your computer in the event of a power
          failure. User manual: http://www.apcupsd.com/manual/manual.html.
          Note that apcupsd runs as root (to allow shutdown of computer).
          You can check the status of your UPS with the "apcaccess" command.
        '';
      };

      configText = mkOption {
        default = ''
          UPSTYPE usb
          NISIP 127.0.0.1
          BATTERYLEVEL 50
          MINUTES 5
        '';
        type = types.lines;
        description = lib.mdDoc ''
          Contents of the runtime configuration file, apcupsd.conf. The default
          settings makes apcupsd autodetect USB UPSes, limit network access to
          localhost and shutdown the system when the battery level is below 50
          percent, or when the UPS has calculated that it has 5 minutes or less
          of remaining power-on time. See man apcupsd.conf for details.
        '';
      };

      hooks = mkOption {
        default = {};
        example = {
          doshutdown = "# shell commands to notify that the computer is shutting down";
        };
        type = types.attrsOf types.lines;
        description = lib.mdDoc ''
          Each attribute in this option names an apcupsd event and the string
          value it contains will be executed in a shell, in response to that
          event (prior to the default action). See "man apccontrol" for the
          list of events and what they represent.

          A hook script can stop apccontrol from doing its default action by
          exiting with value 99. Do not do this unless you know what you're
          doing.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [ {
      assertion = let hooknames = builtins.attrNames cfg.hooks; in all (x: elem x eventList) hooknames;
      message = ''
        One (or more) attribute names in services.apcupsd.hooks are invalid.
        Current attribute names: ${toString (builtins.attrNames cfg.hooks)}
        Valid attribute names  : ${toString eventList}
      '';
    } ];

    # Give users access to the "apcaccess" tool
    environment.systemPackages = [ pkgs.apcupsd ];

    # NOTE 1: apcupsd runs as root because it needs permission to run
    # "shutdown"
    #
    # NOTE 2: When apcupsd calls "wall", it prints an error because stdout is
    # not connected to a tty (it is connected to the journal):
    #   wall: cannot get tty name: Inappropriate ioctl for device
    # The message still gets through.
    systemd.services.apcupsd = {
      description = "APC UPS Daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = "mkdir -p /run/apcupsd/";
      serviceConfig = {
        ExecStart = "${pkgs.apcupsd}/bin/apcupsd -b -f ${configFile} -d1";
        # TODO: When apcupsd has initiated a shutdown, systemd always ends up
        # waiting for it to stop ("A stop job is running for UPS daemon"). This
        # is weird, because in the journal one can clearly see that apcupsd has
        # received the SIGTERM signal and has already quit (or so it seems).
        # This reduces the wait time from 90 seconds (default) to just 5. Then
        # systemd kills it with SIGKILL.
        TimeoutStopSec = 5;
      };
      unitConfig.Documentation = "man:apcupsd(8)";
    };

    # A special service to tell the UPS to power down/hibernate just before the
    # computer shuts down. (The UPS has a built in delay before it actually
    # shuts off power.) Copied from here:
    # http://forums.opensuse.org/english/get-technical-help-here/applications/479499-apcupsd-systemd-killpower-issues.html
    systemd.services.apcupsd-killpower = {
      description = "APC UPS Kill Power";
      after = [ "shutdown.target" ]; # append umount.target?
      before = [ "final.target" ];
      wantedBy = [ "shutdown.target" ];
      unitConfig = {
        ConditionPathExists = "/run/apcupsd/powerfail";
        DefaultDependencies = "no";
      };
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.apcupsd}/bin/apcupsd --killpower -f ${configFile}";
        TimeoutSec = "infinity";
        StandardOutput = "tty";
        RemainAfterExit = "yes";
      };
    };

  };

}
