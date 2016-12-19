{ config, lib, ... }:

with lib;

{

  ###### interface

  options = {

    boot.cleanTmpDir = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to delete all files in <filename>/tmp</filename> during boot.
      '';
    };

    boot.tmpOnTmpfs = mkOption {
      type = types.bool;
      default = false;
      description = ''
         Whether to mount a tmpfs on <filename>/tmp</filename> during boot.
      '';
    };

  };

  ###### implementation

  config = {

    systemd.additionalUpstreamSystemUnits = optional config.boot.tmpOnTmpfs "tmp.mount";

    systemd.tmpfiles.rules = optional config.boot.cleanTmpDir "D! /tmp 1777 root root";

  };

}