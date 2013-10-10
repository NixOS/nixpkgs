{ config, pkgs, ... }:

with pkgs.lib;

{

  ###### interface

  options = {

    services.mingetty = {

      greetingLine = mkOption {
        default = ''<<< Welcome to NixOS ${config.system.nixosVersion} (\m) - \l >>>'';
        description = ''
          Welcome line printed by mingetty.
        '';
      };

      helpLine = mkOption {
        default = "";
        description = ''
          Help line printed by mingetty below the welcome line.
          Used by the installation CD to give some hints on
          how to proceed.
        '';
      };

    };

  };


  ###### implementation

  config = {

    # FIXME: these are mostly copy/pasted from the systemd sources,
    # which some small modifications, which is annoying.

    # Generate a separate job for each tty.
    systemd.units."getty@.service".text =
      ''
        [Unit]
        Description=Getty on %I
        Documentation=man:agetty(8)
        After=systemd-user-sessions.service plymouth-quit-wait.service

        # If additional gettys are spawned during boot then we should make
        # sure that this is synchronized before getty.target, even though
        # getty.target didn't actually pull it in.
        Before=getty.target
        IgnoreOnIsolate=yes

        ConditionPathExists=/dev/tty0

        [Service]
        Environment=TERM=linux
        Environment=LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive
        ExecStart=@${pkgs.utillinux}/sbin/agetty agetty --noclear --login-program ${pkgs.shadow}/bin/login %I 38400
        Type=idle
        Restart=always
        RestartSec=0
        UtmpIdentifier=%I
        TTYPath=/dev/%I
        TTYReset=yes
        TTYVHangup=yes
        TTYVTDisallocate=yes # set to no to prevent clearing the screen
        KillMode=process
        IgnoreSIGPIPE=no

        # Some login implementations ignore SIGTERM, so we send SIGHUP
        # instead, to ensure that login terminates cleanly.
        KillSignal=SIGHUP

        X-RestartIfChanged=false
      '';
    
    systemd.units."serial-getty@.service".text =
      ''
        [Unit]
        Description=Serial Getty on %I
        Documentation=man:agetty(8) man:systemd-getty-generator(8)
        BindsTo=dev-%i.device
        After=dev-%i.device systemd-user-sessions.service plymouth-quit-wait.service

        # If additional gettys are spawned during boot then we should make
        # sure that this is synchronized before getty.target, even though
        # getty.target didn't actually pull it in.
        Before=getty.target
        IgnoreOnIsolate=yes

        [Service]
        Environment=TERM=linux
        Environment=LOCALE_ARCHIVE=/run/current-system/sw/lib/locale/locale-archive
        ExecStart=@${pkgs.utillinux}/sbin/agetty agetty --login-program ${pkgs.shadow}/bin/login %I 115200,57600,38400,9600
        Type=idle
        Restart=always
        RestartSec=0
        UtmpIdentifier=%I
        TTYPath=/dev/%I
        TTYReset=yes
        TTYVHangup=yes
        KillMode=process
        IgnoreSIGPIPE=no

        # Some login implementations ignore SIGTERM, so we send SIGHUP
        # instead, to ensure that login terminates cleanly.
        KillSignal=SIGHUP
        
        X-RestartIfChanged=false
      '';

    environment.etc = singleton
      { # Friendly greeting on the virtual consoles.
        source = pkgs.writeText "issue" ''

          [1;32m${config.services.mingetty.greetingLine}[0m
          ${config.services.mingetty.helpLine}

        '';
        target = "issue";
      };

  };

}
