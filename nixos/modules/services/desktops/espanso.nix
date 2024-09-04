{ config, lib, pkgs, ... }:

with lib;
let cfg = config.services.espanso;
in {
  meta = { maintainers = with lib.maintainers; [ numkem ]; };

  options = {
    services.espanso = {
      enable = mkEnableOption "Espanso";
      wayland = mkEnableOption "use the Wayland compatible espanso package";
      package = mkPackageOption pkgs "espanso" {
        example = "pkgs.espanso-wayland";
      };
    };
  };

  config =
    let
      wayland = cfg.package == pkgs.espanso-wayland;
    in
    mkMerge [
      (mkIf cfg.enable {
        systemd.user.services.espanso = {
          description = "Espanso daemon";
          serviceConfig = {
            ExecStart =
              # Espanso responsibly tries to drop capabilities as soon as possible
              # but forks *after* dropping, leaving the `worker` process without the
              # capabilities required for the EVDEV backend for wayland. Running
              # `worker` directly from the wrapper works around this issue.
              # https://github.com/NixOS/nixpkgs/issues/249364#issuecomment-2322837290
              if wayland then "/run/wrappers/bin/espanso worker" else "${lib.getExe cfg.package} daemon";
            Restart = "on-failure";
          };
          wantedBy = [ "default.target" ];
        };

        environment.systemPackages = [ cfg.package ];
      })
      (mkIf wayland {
        security.wrappers.espanso = {
          source = "${lib.getExe cfg.package}";
          capabilities = "cap_dac_override+p";
          owner = "root";
          group = "root";
        };
      })
    ];
}
