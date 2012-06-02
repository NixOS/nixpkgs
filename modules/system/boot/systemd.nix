{ config, pkgs, ... }:

with pkgs.lib;

let

  systemd = pkgs.systemd;

  makeUnit = name: text:
    pkgs.writeTextFile { name = "unit"; inherit text; destination = "/${name}"; };

  defaultTarget = makeUnit "default.target"
    ''
      [Unit]
      Description=Default System
      Requires=getty.target
      After=getty.target
      Conflicts=rescue.target
      AllowIsolate=yes
    '';

  gettyTarget = makeUnit "getty.target"
    ''
      [Unit]
      Description=Login Prompts
      Requires=getty@tty1.service getty@tty2.service
      After=getty@tty1.service getty@tty2.service
    '';

  gettyService = makeUnit "getty@.service"
    ''
      [Unit]
      Description=Getty on %I
      #BindTo=dev-%i.device
      #After=dev-%i.device systemd-user-sessions.service plymouth-quit-wait.service
      Before=getty.target

      [Service]
      Environment=TERM=linux
      ExecStart=-${pkgs.utillinux}/sbin/agetty --noclear --login-program ${pkgs.shadow}/bin/login %I 38400
      Restart=always
      RestartSec=0
      UtmpIdentifier=%I
      TTYPath=/dev/%I
      TTYReset=yes
      TTYVHangup=yes
      TTYVTDisallocate=yes
      KillMode=process
      IgnoreSIGPIPE=no

      # Unset locale for the console getty since the console has problems
      # displaying some internationalized messages.
      Environment=LANG= LANGUAGE= LC_CTYPE= LC_NUMERIC= LC_TIME= LC_COLLATE= LC_MONETARY= LC_MESSAGES= LC_PAPER= LC_NAME= LC_ADDRESS= LC_TELEPHONE= LC_MEASUREMENT= LC_IDENTIFICATION=

      # Some login implementations ignore SIGTERM, so we send SIGHUP
      # instead, to ensure that login terminates cleanly.
      KillSignal=SIGHUP
    '';

  rescueTarget = makeUnit "rescue.target"
    ''
      [Unit]
      Description=Rescue Mode
      Requires=rescue.service
      After=rescue.service
      AllowIsolate=yes
    '';

  rescueService = makeUnit "rescue.service"
    ''
      [Unit]
      Description=Rescue Shell
      DefaultDependencies=no
      #After=basic.target
      #Before=shutdown.target

      [Service]
      Environment=HOME=/root
      WorkingDirectory=/root
      ExecStartPre=-${pkgs.coreutils}/bin/echo 'Welcome to rescue mode. Use "systemctl default" or ^D to enter default mode.'
      #ExecStart=-/sbin/sulogin
      ExecStart=-${pkgs.bashInteractive}/bin/bash --login
      ExecStopPost=-${systemd}/bin/systemctl --fail --no-block default
      StandardInput=tty-force
      StandardOutput=inherit
      StandardError=inherit
      KillMode=process

      # Bash ignores SIGTERM, so we send SIGHUP instead, to ensure that bash
      # terminates cleanly.
      KillSignal=SIGHUP
    '';

  upstreamUnits =
    [ "systemd-journald.socket"
      "systemd-journald.service"
      "basic.target"
      "sysinit.target"
      "sysinit.target.wants"
      "sockets.target"
      "sockets.target.wants"

      # Filesystems.
      "local-fs.target"
      "local-fs.target.wants"
      "local-fs-pre.target"
      "remote-fs.target"
      "remote-fs-pre.target"
      "swap.target"
      "media.mount"
      "dev-mqueue.mount"

      # Reboot stuff.
      "reboot.target"
      "reboot.service"
      "poweroff.target"
      "poweroff.service"
      "halt.target"
      "halt.service"
      "ctrl-alt-del.target"
      "shutdown.target"
      "umount.target"
      "final.target"
    ];

  systemUnits = pkgs.runCommand "system-units" { }
    ''
      mkdir -p $out/system
      for i in ${toString upstreamUnits}; do
        fn=${systemd}/example/systemd/system/$i
        echo $fn
        [ -e $fn ]
        ln -s $fn $out/system
      done
      for i in ${toString [ defaultTarget gettyTarget gettyService rescueTarget rescueService ]}; do
        cp $i/* $out/system
      done
    ''; # */
    
in

{

  ###### implementation

  config = {

    environment.systemPackages = [ systemd ];
  
    environment.etc =
      [ { source = systemUnits;
          target = "systemd";
        }
      ];
    
  };

}
