{ substituteAll, coreutils
, utillinux, kernel, udev, upstart
, activateConfiguration

, # Whether the root device is root only.  If so, we'll mount a
  # ramdisk on /etc, /var and so on.
  readOnlyRoot

, # Path for Upstart jobs.  Should be quite minimal.
  upstartPath
}:

let

  startPath = [
    coreutils
    utillinux
    udev
    upstart
  ];

in

substituteAll {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit kernel upstart readOnlyRoot activateConfiguration upstartPath;
  inherit startPath;
}
