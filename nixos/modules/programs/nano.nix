{ config, lib, pkgs, ... }:

let
  cfg = config.programs.nano;
in

{
  options = {
    programs.nano = {
      enable = lib.mkEnableOption (lib.mdDoc "nano") // {
        default = true;
      };

      package = lib.mkPackageOption pkgs "nano" { };

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

  config = lib.mkIf cfg.enable {
    environment = {
      etc.nanorc.text = (lib.optionalString cfg.syntaxHighlight ''
        # load syntax highlighting files
        include "${cfg.package}/share/nano/*.nanorc"
        include "${cfg.package}/share/nano/extra/*.nanorc"
      '') + cfg.nanorc;
      systemPackages = [ cfg.package ];
    };
  };
}
