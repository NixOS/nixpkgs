# This module allows the test driver to connect to the virtual machine
# via a root shell attached to port 514.

{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    jobs.backdoor =
      { startOn = "started network-interfaces";
        
        preStart =
          ''
            echo "guest running" > /dev/ttyS0
            echo "===UP===" > dev/ttyS0
          '';
          
        exec = "${pkgs.socat}/bin/socat tcp-listen:514,fork exec:/bin/sh 2> /dev/ttyS0";
      };
  
    boot.postBootCommands =
      ''
        # Panic on out-of-memory conditions rather than letting the
        # OOM killer randomly get rid of processes, since this leads
        # to failures that are hard to diagnose.
        echo 2 > /proc/sys/vm/panic_on_oom

        # Coverage data is written into /tmp/coverage-data.  Symlink
        # it to the host filesystem so that we don't need to copy it
        # on shutdown.
        ( eval $(cat /proc/cmdline)
          mkdir /hostfs/$hostTmpDir/coverage-data
          ln -s /hostfs/$hostTmpDir/coverage-data /tmp/coverage-data
        )

        # Mount debugfs to gain access to the kernel coverage data (if
        # available).
        mount -t debugfs none /sys/kernel/debug || true
      '';

    # If the kernel has been built with coverage instrumentation, make
    # it available under /proc/gcov.
    boot.kernelModules = [ "gcov-proc" ];

    # Panic if an error occurs in stage 1 (rather than waiting for
    # user intervention). 
    boot.kernelParams = [ "stage1panic" ];
      
  };

}
