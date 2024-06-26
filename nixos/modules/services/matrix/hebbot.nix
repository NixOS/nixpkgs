{
  lib,
  config,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  format = pkgs.formats.toml { };
  cfg = config.services.hebbot;
  settingsFile = format.generate "config.toml" cfg.settings;
  mkTemplateOption =
    templateName:
    mkOption {
      type = types.path;
      description = ''
        A path to the Markdown file for the ${templateName}.
      '';
    };
in
{
  meta.maintainers = [ lib.maintainers.raitobezarius ];
  options.services.hebbot = {
    enable = mkEnableOption "hebbot";
    botPasswordFile = mkOption {
      type = types.path;
      description = ''
        A path to the password file for your bot.

        Consider using a path that does not end up in your Nix store
        as it would be world readable.
      '';
    };
    templates = {
      project = mkTemplateOption "project template";
      report = mkTemplateOption "report template";
      section = mkTemplateOption "section template";
    };
    settings = mkOption {
      type = format.type;
      default = { };
      description = ''
        Configuration for Hebbot, see, for examples:

        - <https://github.com/matrix-org/twim-config/blob/master/config.toml>
        - <https://gitlab.gnome.org/Teams/Websites/thisweek.gnome.org/-/blob/main/hebbot/config.toml>
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hebbot = {
      description = "hebbot - a TWIM-style Matrix bot written in Rust";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ln -sf ${cfg.templates.project} ./project_template.md
        ln -sf ${cfg.templates.report} ./report_template.md
        ln -sf ${cfg.templates.section} ./section_template.md
        ln -sf ${settingsFile} ./config.toml
      '';

      script = ''
        export BOT_PASSWORD="$(cat $CREDENTIALS_DIRECTORY/bot-password-file)"
        ${lib.getExe pkgs.hebbot}
      '';

      serviceConfig = {
        DynamicUser = true;
        Restart = "on-failure";
        LoadCredential = "bot-password-file:${cfg.botPasswordFile}";
        RestartSec = "10s";
        StateDirectory = "hebbot";
        WorkingDirectory = "hebbot";
      };
    };
  };
}
