{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.espanso;
in
{
  meta = {
    maintainers = with lib.maintainers; [
      n8henrie
      numkem
    ];
  };

  options = {
    services.espanso = {
      enable = lib.mkEnableOption "Espanso";
      package = lib.mkPackageOption pkgs "espanso" {
        example = "pkgs.espanso-wayland";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers.espanso = lib.mkIf (cfg.package == pkgs.espanso-wayland) {
      capabilities = "cap_dac_override+p";
      owner = "root";
      group = "root";
      source = lib.getExe (
        pkgs.espanso-wayland.overrideAttrs (old: {
          patchPhase =
            old.patchPhase or ""
            + ''
              substituteInPlace espanso/src/cli/daemon/mod.rs \
                  --replace-fail \
                    'std::env::current_exe().expect("unable to obtain espanso executable location");' \
                    'std::ffi::OsString::from("/run/wrappers/bin/espanso");'
            '';
        })
      );

    };
    systemd.user.services.espanso = {
      description = "Espanso daemon";
      serviceConfig = {
        ExecStart = "${
          if (cfg.package == pkgs.espanso-wayland) then
            "/run/wrappers/bin/espanso"
          else
            lib.getExe cfg.package
        } daemon";
        Restart = "on-failure";
      };
      wantedBy = [ "default.target" ];
    };

    environment.systemPackages = [ cfg.package ];
  };
}
