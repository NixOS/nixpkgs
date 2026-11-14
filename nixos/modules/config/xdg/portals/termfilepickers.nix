{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.xdg.portal.termfilepickers;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "xdg-desktop-portal-termfilepickers.toml" cfg.settings;

  scriptOption =
    script: description:
    lib.mkOption {
      type = lib.types.path;
      default = "${cfg.package}/share/wrappers/${script}";
      defaultText = lib.literalExpression ''"''${config.xdg.portal.termfilepickers.package}/share/wrappers/${script}"'';
      inherit description;
    };
in
{
  meta = {
    maintainers = with lib.maintainers; [ anish ];
  };

  options.xdg.portal.termfilepickers = {
    enable = lib.mkEnableOption "xdg-desktop-portal-termfilepickers";

    package = lib.mkOption {
      type = lib.types.package;
      default =
        if config.programs.yazi.enable then
          pkgs.xdg-desktop-portal-termfilepickers.override { yazi = config.programs.yazi.finalPackage; }
        else
          pkgs.xdg-desktop-portal-termfilepickers;
      defaultText = lib.literalExpression ''
        if config.programs.yazi.enable then
          pkgs.xdg-desktop-portal-termfilepickers.override { yazi = config.programs.yazi.finalPackage; }
        else
          pkgs.xdg-desktop-portal-termfilepickers
      '';
      description = "The xdg-desktop-portal-termfilepickers package";
    };

    desktopEnvironments = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "common" ];
      description = "Lowercase names of the desktop environments to enable the service for";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          open_file_script_path = scriptOption "yazi-open-file.nu" "The path to the script that will be used to open files";
          save_file_script_path = scriptOption "yazi-save-file.nu" "The path to the script that will be used to save files";
          # this is not a typo, the package does not provide a separate script for saving multiple files
          save_files_script_path = scriptOption "yazi-save-file.nu" "The path to the script that will be used to save files";

          terminal_command = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            example = lib.literalExpression ''[ (lib.getExe pkgs.kitty) "--title" "filepicker" ]'';
            description = "The terminal command to use for opening files";
          };
        };
      };
      default = { };
      description = "Configuration for `xdg-desktop-portal-termfilepickers`.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ cfg.package ];
      config = lib.genAttrs cfg.desktopEnvironments (_: {
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilepickers" ];
      });
    };

    systemd.user.services.xdg-desktop-portal-termfilepickers = {
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "xdg-desktop-portal.service" ];
      after = [
        "graphical-session.target"
        "xdg-desktop-portal.service"
      ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} --config-path ${configFile}";
        Restart = "on-failure";
      };
    };
  };
}
