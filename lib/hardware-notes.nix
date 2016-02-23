{ config, lib, pkgs, ... }:

with lib;

let
  # use tail recursion to prevent whitespace padding
  mkLog = list:
    let
      head = builtins.head list;
      tail = builtins.tail list;
    in
    ''
      # ${head.title}
      ${head.text}${if tail == [] then "" else "\n\n${mkLog tail}"}
    '';
in

{

  options = {
    hardwareNotes = mkOption {
      internal = true;
      type = types.listOf types.optionSet;
      options = {
        title = mkOption {
          type = types.str;
          example = "Thunkpad-2000: increase self-destruct timeout";
        };
        text = mkOption {
	  type = types.str;
          example =
            ''
              Increase security timeout at boot using platform managment
              tool to prevent premature data loss.
            '';
        };
      };
    };
  };

  config = {
    environment.etc."hardware-notes".text = mkLog config.hardwareNotes;
  };

}
