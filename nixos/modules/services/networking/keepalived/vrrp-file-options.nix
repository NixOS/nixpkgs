{ lib }:

with lib;
with lib.types;
{
  options = {
    file = mkOption {
      type = str;
      example = "/run/maintenance";
      description = "(Path of) The file to track. File content is interpreted as a number. Note that you probably don't want this to live in keepalived's RuntimeDirectory.";
    };

    weight = mkOption {
      type = int;
      default = 0;
      description = "Multiply the file's value by this factor. If zero, any non-zero number in the file means FAULT.";
    };

    reverse = lib.mkOption {
      type = bool;
      default = false;
      description = "Negate the file's value before applying.";
    };

    init = {
      value = lib.mkOption {
        type = nullOr int;
        default = null;
        example = 0;
        description = "Create the file with this value on startup.";
      };
      overwrite = lib.mkOption {
        type = bool;
        default = false;
        description = "Write init.value even if the file already exists.";
      };
    };

    extraConfig = mkOption {
      type = lines;
      default = "";
      description = "Extra lines to be added verbatim to the track_file section.";
    };
  };
}
