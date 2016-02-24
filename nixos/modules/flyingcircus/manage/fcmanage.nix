{ pkgs, fetchurl, lib, pythonPackages, ...}:

# Our management agent keeping the system up to date, configuring it based on
# changes to our nixpkgs clone and data from our directory

with lib;

# Need to turn this into a real package once we require more
pkgs.stdenv.mkDerivation {
  name = "fc-manage-0.1";

  src = ./src;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/*.py $out/

    cat <<__EOF__ > $out/bin/fc-manage
    #!/bin/bash
    # The current system reference is bad because I wasn't able tof figure out
    # retrieving the path of all all dependencies (and theirs).
    PATH=/run/current-system/sw/bin:/run/current-system/sw/sbin
    ${pkgs.python3}/bin/python3 $out/fc-manage.py \$@
    __EOF__
    chmod +x $out/bin/fc-manage

    cat <<__EOF__ > $out/bin/fc-resize-root
    #!/bin/bash
    # The current system reference is bad because I wasn't able tof figure out
    # retrieving the path of all all dependencies (and theirs).
    PATH=${pkgs.gptfdisk}/bin:${pkgs.utillinux}/bin:/run/current-system/sw/bin:/run/current-system/sw/sbin
    ${pkgs.python3}/bin/python3 $out/fc-resize-root.py \$@
    __EOF__
    chmod +x $out/bin/fc-resize-root

    cat <<__EOF__ > $out/bin/fc-get-disk-alias
    #!/bin/bash
    # The current system reference is bad because I wasn't able tof figure out
    # retrieving the path of all all dependencies (and theirs).
    PATH=${pkgs.utillinux}/bin:/run/current-system/sw/bin:/run/current-system/sw/sbin
    ${pkgs.python3}/bin/python3 $out/fc-get-disk-alias.py \$@
    __EOF__
    chmod +x $out/bin/fc-get-disk-alias

    mkdir -p $out/etc/udev/rules.d

    echo "SUBSYSTEM==\"block\", PROGRAM=\"$out/bin/fc-get-disk-alias %k\", SYMLINK+=\"%c\"" > $out/etc/udev/rules.d/10-fc-disk-alias.rules

    cat <<__EOF__ > $out/bin/fc-monitor
    #!/bin/bash
    # The current system reference is bad because I wasn't able tof figure out
    # retrieving the path of all all dependencies (and theirs).
    PATH=${pkgs.utillinux}/bin:/run/current-system/sw/bin:/run/current-system/sw/sbin
    ${pkgs.python3}/bin/python3 $out/fc-monitor.py \$@
    __EOF__
    chmod +x $out/bin/fc-monitor

    '';
}
