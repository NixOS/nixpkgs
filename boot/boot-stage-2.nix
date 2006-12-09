{ genericSubstituter, shell, coreutils, findutils
, gnugrep, utillinux, kernel, udev, upstart
, activateConfiguration

, # Whether the root device is root only.  If so, we'll mount a
  # ramdisk on /etc, /var and so on.
  readOnlyRoot
}:

let

  startPath = [
    coreutils
    findutils
    gnugrep
    utillinux
    udev
    upstart
  ];

in

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell kernel upstart readOnlyRoot activateConfiguration;
  inherit startPath;
}
