{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.dsym;
  iniFormat = pkgs.formats.ini { };

in
{
  options.programs.dsym = {
    enable = lib.mkEnableOption "DSYM, a Python dotfile manager.";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.dsym;
      defaultText = lib.literalExpression "pkgs.dsym";
      description = "The dsym package to use";
    };

    machineName = lib.mkOption {
      type = lib.types.str;
      default = "my-machine";
      description = "A unique identifier for this machine.";
    };

    dotfileRepo = lib.mkOption {
      type = lib.types.str;
      example = "https://github.com/username/dotfiles";
      description = "URL to your dotfile Git repository.";
    };

    dotfilePath = lib.mkOption {
      type = lib.types.path;
      default = { };
      description = "The local path to where your dotfiles are stored.";
    };

    dsymPath = lib.mkOption {
      type = lib.types.path;
      default = { };
      description = "The path where DSYM should operate or store data.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."dsym/config.ini".source = iniFormat.generate "dsym-config.ini" {
      Settings = {
      machine_name = cfg.machineName;
      dotfile_repo = cfg.dotfileRepo;
      dotfile_path = toString cfg.dotfilePath;
      dsym_path = toString cfg.dsymPath;
    };
  };
};

meta.maintainers = with lib.maintainers; [

  _0x17

];

}
