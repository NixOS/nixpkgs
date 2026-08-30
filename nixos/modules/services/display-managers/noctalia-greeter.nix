# adapted from upstream
{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.displayManager.noctalia-greeter;
  format = pkgs.formats.toml { };

  inherit (lib)
    escapeShellArgs
    getExe'
    maintainers
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optionalAttrs
    ;

  inherit (lib.types)
    listOf
    str
    ;
in
{
  options.services.displayManager.noctalia-greeter = {
    enable = mkEnableOption "Noctalia Greeter, a minimal login greeter for greetd";

    package = mkPackageOption pkgs "noctalia-greeter" { };

    extraArgs = mkOption {
      description = "Arguments to add to the noctalia-greeter-session invocation.";
      type = listOf str;
      default = [ ];
    };

    settings = mkOption {
      description = ''
        Settings for noctalia-greeter written to greeter.toml.

        Note that it also can contain some state, like the most recently used
        session, which will be clobbered on every activation and boot. This is
        due to an upstream limitation; the state is due to be moved to another
        file.
      '';
      inherit (format) type;
      default = { };
      example = {
        cursor = {
          theme = "Adwaita";
          size = 24;
        };
        keyboard = {
          layout = "us";
        };
      };
    };

    cursorTheme = {
      package = mkPackageOption pkgs "cursor theme" {
        nullable = true;
        default = null;
      };

      name = mkOption {
        type = str;
        default = "Adwaita";
        description = ''
          Name of the cursor theme to use for noctalia-greeter.
        '';
      };
    };
  };

  config =
    let
      user = config.services.greetd.settings.default_session.user;
      group =
        let
          g = config.users.users.${user}.group or "";
        in
        if g != "" then g else "greeter";
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = (config.users.users.${user} or { }) != { };
          message = "noctalia-greeter: user ${user} does not exist. Please create it before referencing it.";
        }
      ];

      services.displayManager.noctalia-greeter.settings.cursor = mkIf (cfg.cursorTheme.package != null) {
        theme = mkDefault cfg.cursorTheme.name;
        path = mkDefault "${cfg.cursorTheme.package}/share/icons";
      };

      environment.systemPackages = [ cfg.package ];

      systemd.tmpfiles.settings."10-noctalia-greeter" = {
        "/var/lib/noctalia-greeter".d = {
          inherit user group;
          mode = "0750";
        };
      }
      // optionalAttrs (cfg.settings != { }) {
        "/var/lib/noctalia-greeter/greeter.toml"."L+" = {
          argument = "${format.generate "greeter.toml" cfg.settings}";
          inherit user group;
          mode = "0644";
        };
      };

      services.greetd = {
        enable = mkDefault true;
        settings.default_session.command = mkDefault "${getExe' cfg.package "noctalia-greeter-session"} ${escapeShellArgs cfg.extraArgs}";
      };

      security.polkit.enable = mkDefault true;
      services.accounts-daemon.enable = mkDefault true;
    };

  meta.maintainers = with maintainers; [
    dtomvan
    samiser
  ];
}
