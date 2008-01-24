{ substituteAll, writeText, coreutils
, utillinux, kernel, udev, upstart
, activateConfiguration

, # Whether the root device is read-only and should be made writable
  # through a unionfs.
  isLiveCD

, # Path for Upstart jobs.  Should be quite minimal.
  upstartPath

, # User-supplied command to be run just before Upstart is started.
  bootLocal ? ""
}:

substituteAll {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit kernel upstart isLiveCD activateConfiguration upstartPath;
  path = [
    coreutils
    utillinux
    udev
    upstart
  ];
  bootLocal = writeText "local-cmds" bootLocal;
}
