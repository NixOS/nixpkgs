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

    boot.tmpFsSize = mkOption {
        default = "90%";
        example = "256m";
        type = types.str;
        description = ''
          Size limit for the <filename>/tmp</filename> tmpfs. Look at mount(8), tmpfs size option,
          for the accepted syntax.
        '';
    };
  };

}
