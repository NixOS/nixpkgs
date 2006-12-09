{ genericSubstituter, buildEnv, shell, coreutils, findutils
, gnugrep, utillinux, kernel, udev, upstart, setuidWrapper
, path ? []

, # Whether the root device is root only.  If so, we'll mount a
  # ramdisk on /etc, /var and so on.
  readOnlyRoot

, # The Upstart job configuration.
  upstartJobs

, # Static configuration files to be placed (through symlinks) in
  # /etc.
  etc

, hostName
}:

let

  startPath = [
    coreutils
    findutils
    gnugrep
    utillinux
    udev
    upstart
    setuidWrapper
  ];

in

genericSubstituter {
  src = ./boot-stage-2-init.sh;
  isExecutable = true;
  inherit shell kernel upstart readOnlyRoot upstartJobs etc hostName;
  inherit startPath;

  # We don't want to put all of `startPath' and `path' in $PATH, since
  # then we get an embarrassingly long $PATH.  So use the user
  # environment builder to make a directory with symlinks to those
  # packages.
  fullPath = buildEnv {
    name = "boot-stage-2-path";
    paths = startPath ++ path;
    pathsToLink = ["/bin" "/sbin" "/man/man1" "/share/man/man1"];
    ignoreCollisions = true;
  };

  wrapperDir = setuidWrapper.wrapperDir;

  accounts = ../helpers/accounts.sh;
}
