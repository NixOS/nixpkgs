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
    environment.etc.nanorc.text = lib.concatStrings [ cfg.nanorc
      (lib.optionalString cfg.syntaxHighlight ''${LF}include "${pkgs.nano}/share/nano/*.nanorc"'') ];
  };

}
