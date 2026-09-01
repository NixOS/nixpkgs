{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.noctalia;
in
{
  options.programs.noctalia = {
    enable = lib.mkEnableOption "noctalia, a sleek and customizable desktop shell for Wayland";

    package = lib.mkPackageOption pkgs "noctalia" { };

    systemd = {
      enable = lib.mkEnableOption "a systemd user service for noctalia";

      target = lib.mkOption {
        type = lib.types.str;
        default = "graphical-session.target";
        example = "hyprland-session.target";
        description = ''
          The systemd user target that will automatically start the noctalia service.
        '';
      };
    };

    recommendedServices.enable = lib.mkEnableOption "the services used by noctalia's integrations, namely NetworkManager, bluetooth, UPower and a power profile daemon";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ cfg.package ];

        systemd.user.services.noctalia = lib.mkIf cfg.systemd.enable {
          description = "Noctalia Wayland desktop shell";
          documentation = [ "https://docs.noctalia.dev/v5/" ];
          partOf = [ cfg.systemd.target ];
          after = [ cfg.systemd.target ];
          wantedBy = [ cfg.systemd.target ];

          enableDefaultPath = false;

          serviceConfig = {
            ExecStart = lib.getExe cfg.package;
            Restart = "on-failure";
          };
        };
      }

      (lib.mkIf cfg.recommendedServices.enable {
        networking.networkmanager.enable = lib.mkDefault true;
        hardware.bluetooth.enable = lib.mkDefault true;
        services.upower.enable = lib.mkDefault true;
        services.power-profiles-daemon.enable = lib.mkDefault true;
      })
    ]
  );

  meta.maintainers = with lib.maintainers; [
    samiser
    pyrox0
  ];
}
