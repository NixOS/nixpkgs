{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nano;
  LF = "\n";
in

{
  ###### interface

  options = {
    programs.nano = {

      nanorc = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = lib.mdDoc ''
          The system-wide nano configuration.
          See {manpage}`nanorc(5)`.
        '';
        example = ''
          set nowrap
          set tabstospaces
          set tabsize 2
        '';
      };
      syntaxHighlight = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc "Whether to enable syntax highlight for various languages.";
      };
    };
  };

  ###### implementation

  config = lib.mkIf (cfg.nanorc != "" || cfg.syntaxHighlight) {
<<<<<<< HEAD
    environment.etc.nanorc.text = lib.concatStringsSep LF (
      ( lib.optionals cfg.syntaxHighlight [
          "# The line below is added because value of programs.nano.syntaxHighlight is set to true"
          ''include "${pkgs.nano}/share/nano/*.nanorc"''
          ""
      ])
      ++ ( lib.optionals (cfg.nanorc != "") [
        "# The lines below have been set from value of programs.nano.nanorc"
        cfg.nanorc
      ])
    );
=======
    environment.etc.nanorc.text = lib.concatStrings [ cfg.nanorc
      (lib.optionalString cfg.syntaxHighlight ''${LF}include "${pkgs.nano}/share/nano/*.nanorc"'') ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

}
