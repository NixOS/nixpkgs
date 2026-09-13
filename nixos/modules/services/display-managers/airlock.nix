{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.displayManager.airlock;
  user = config.services.greetd.settings.default_session.user;
  group =
    let
      g = config.users.users.${user}.group or "";
    in
    if g != "" then g else "greeter";
in
{
  options.services.displayManager.airlock = {
    enable = lib.mkEnableOption "Airlock, a clean and modern Material Design 3 Quickshell greeter for greetd";

    package = lib.mkPackageOption pkgs "airlock" { };

    compositor = {
      package = lib.mkPackageOption pkgs "cage" { };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ "-s" ];
        example = [
          "-s"
          "-m"
          "last"
        ];
        description = ''
          Arguments to pass to the compositor (defaults to cage).
        '';
      };
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--only"
        "DP-1"
      ];
      description = ''
        Extra command-line arguments to pass to {command}`astra-airlock` (e.g. display output options).
      '';
    };

    syncDynamicScheme = {
      enable = lib.mkEnableOption "sudoers permissions for wheel users to sync active desktop themes to the greeter non-interactively";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (config.users.users.${user} or { }) != { };
        message = "airlock: user ${user} does not exist. Please create it before referencing it.";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    services.accounts-daemon.enable = lib.mkDefault true;
    hardware.graphics.enable = lib.mkDefault true;

    fonts.packages = with pkgs; [
      material-symbols
    ];

    systemd.tmpfiles.settings."10-airlock" = {
      "/var/cache/astra-airlock".d = {
        inherit user group;
        mode = "0755";
      };
      "/var/cache/astra-airlock/schemes".d = {
        inherit user group;
        mode = "0755";
      };
      "/var/cache/astra-airlock/schemes/dynamic".d = {
        inherit user group;
        mode = "0777";
      };
    };

    services.greetd = {
      enable = lib.mkDefault true;
      settings.default_session = {
        command = lib.mkDefault (
          lib.escapeShellArgs (
            [
              (lib.getExe cfg.compositor.package)
            ]
            ++ cfg.compositor.extraArgs
            ++ [
              "--"
              (lib.getExe cfg.package)
            ]
            ++ cfg.extraArgs
          )
        );
      };
    };

    security.sudo.extraRules = lib.mkIf cfg.syncDynamicScheme.enable [
      {
        commands = [
          {
            command = "${lib.getExe cfg.package} --sync";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${lib.getExe cfg.package} -s";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  meta.maintainers = with lib.maintainers; [
    rachalaraj
  ];
}
