{ substituteAll, writeText, coreutils
, utillinux, kernel, udev, upstart
, activateConfiguration

, # Whether the root device is root only.  If so, we'll mount a
  # ramdisk on /etc, /var and so on.
  readOnlyRoot

, # Path for Upstart jobs.  Should be quite minimal.
  upstartPath

, # User-supplied command to be run just before Upstart is started.
  bootLocal ? ""
}:

substituteAll {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit kernel upstart readOnlyRoot activateConfiguration upstartPath;
  path = [
    coreutils
    utillinux
    udev
    upstart
  ];
  bootLocal = writeText "boot.local" bootLocal;
}
