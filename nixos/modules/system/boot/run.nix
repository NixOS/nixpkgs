{ config, lib, ... }:

with lib;

{

  ###### interface

  options = {

    #TODO:investigate how not to break /run/current-system
    # boot.cleanRunDir = mkOption {
    #   type = types.bool;
    #   default = false;
    #   description = ''
    #     Whether to delete all files in <filename>/run</filename> during boot.
    #   '';
    # };
    boot.runOnTmpfs = mkOption {
      type = types.bool;
      default = false;
      description = ''
         Whether to mount a tmpfs on <filename>/run</filename> during boot.
      '';
    };

  };

  ###### implementation

  config = {

    fileSystems."/run" = mkIf config.boot.runOnTmpfs {
      fsType="tmpfs";
    };

    # systemd.tmpfiles.rules = optional config.boot.cleanRunDir "D! /run 1777 root root";

  };

}
