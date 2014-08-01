{ config, lib, ... }:

let
  cfg = config.programs.nano;
in

{
  ###### interface

  options = {
    programs.nano = {

      nanorc = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          The system-wide nano configuration.
          See <citerefentry><refentrytitle>nanorc</refentrytitle><manvolnum>5</manvolnum></citerefentry>.
        '';
        example = ''
          set nowrap
          set tabstospaces
          set tabsize 4
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf (cfg.nanorc != "") {
    environment.etc."nanorc".text = cfg.nanorc;
  };

}
