# This module allows the test driver to connect to the virtual machine
# via a root shell attached to port 514.

{ config, pkgs, ... }:

with pkgs.lib;

{

  config = {

    jobAttrs.backdoor =
      { startOn = "network-interfaces";
        
        preStart =
          ''
            eval $(cat /proc/cmdline)
            echo "guest running, will write in $hostTmpDir on host" > /dev/ttyS0
            touch /hostfs/$hostTmpDir/running
          '';
          
        exec = "${pkgs.socat}/bin/socat tcp-listen:514,fork exec:/bin/sh,stderr";
      };
  
    boot.postBootCommands =
      ''
        ( eval $(cat /proc/cmdline)
          mkdir /hostfs/$hostTmpDir/coverage-data
          ln -s /hostfs/$hostTmpDir/coverage-data /tmp/coverage-data
        )
      '';

    # If the kernel has been built with coverage instrumentation, make
    # it available under /proc/gcov.
    boot.kernelModules = [ "gcov-proc" ];
      
  };

}
