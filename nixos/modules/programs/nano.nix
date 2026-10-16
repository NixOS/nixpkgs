{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nano;
in

{
  options = {
    programs.nano = {
      enable = lib.mkEnableOption "nano, a small user-friendly console text editor" // {
        default = true;
      };

      defaultEditor = lib.mkEnableOption "nano as the default editor" // {
        default = cfg.enable;
        defaultText = "config.programs.nano.enable";
      };

      package = lib.mkPackageOption pkgs "nano" { };

      nanorc = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
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
        description = "Whether to enable syntax highlight for various languages.";
      };
    };
  };

  config = lib.mkIf (cfg.enable || cfg.defaultEditor) {
    assertions = [
      {
        assertion = cfg.defaultEditor -> cfg.enable;
        message = "{option}`programs.nano.defaultEditor` requires {option}`programs.nano.enable` to be set to true.";
      }
    ];
    environment = {
      etc.nanorc.text =
        (lib.optionalString cfg.syntaxHighlight ''
          # load syntax highlighting files
          include "${cfg.package}/share/nano/*.nanorc"
          include "${cfg.package}/share/nano/extra/*.nanorc"
        '')
        + cfg.nanorc;
      systemPackages = [ cfg.package ];
      variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkDefault "nano");
      pathsToLink = [ "/share/nano" ];
    };
  };
}
