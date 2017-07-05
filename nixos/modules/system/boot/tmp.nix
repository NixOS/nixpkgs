{ config, lib, ... }:

with lib;

let

  conf = config.boot.tmpOnTmpfs;

  size = if isString conf then "size=${conf}" else "";

in

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
      type = with types; either bool string;
      default = false;
      description = ''
         Whether to mount a tmpfs on <filename>/tmp</filename> during boot.
         Setting this to `true` is equivalent to 50% of available memory. For details about valid strings, see `man mount`.
      '';
    };

  };

  ###### implementation

  config = {

    systemd.mounts = mkIf (conf != false) [{
      what = "tmpfs";
      where = "/tmp";
      type = "tmpfs";
      options = concatStringsSep "," (lists.filter (x : x != "") [ "mode=1777" "strictatime" "nosuid" "nodev" size ]);

    }];
    systemd.tmpfiles.rules = optional config.boot.cleanTmpDir "D! /tmp 1777 root root";

  };

}
