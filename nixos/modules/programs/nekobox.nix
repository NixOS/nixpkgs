{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.nekobox;
in
{
  options.programs.nekobox = {
    enable = lib.mkEnableOption "NekoBox proxy client";

    package = lib.mkPackageOption pkgs "nekobox" { };

    tunMode = {
      enable = lib.mkEnableOption "TUN mode support for NekoBox";

      setuid = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to set the SUID bit on the nekobox-core wrapper instead of capabilities.
          Useful if capability elevation fails on custom kernels.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Elevated wrappers for TUN interface creation and routing manipulation
    security.wrappers = lib.mkIf cfg.tunMode.enable {
      nekobox-core = {
        source = "${cfg.package.core or cfg.package}/bin/nekobox_core";
        owner = "root";
        group = "root";
        setuid = cfg.tunMode.setuid;
        capabilities = lib.mkIf (
          !cfg.tunMode.setuid
        ) "cap_net_admin,cap_net_raw,cap_net_bind_service,cap_sys_ptrace,cap_dac_read_search+ep";
      };

      nekobox_core = {
        source = "${cfg.package.core or cfg.package}/bin/nekobox_core";
        owner = "root";
        group = "root";
        setuid = cfg.tunMode.setuid;
        capabilities = lib.mkIf (
          !cfg.tunMode.setuid
        ) "cap_net_admin,cap_net_raw,cap_net_bind_service,cap_sys_ptrace,cap_dac_read_search+ep";
      };
    };

    # Avoid multiple authentication prompts when interacting with systemd-resolved
    security.polkit.extraConfig =
      lib.mkIf (cfg.tunMode.enable && !cfg.tunMode.setuid && config.services.resolved.enable)
        ''
          polkit.addRule(function(action, subject) {
            var allowedActionIds = [
              "org.freedesktop.resolve1.set-domains",
              "org.freedesktop.resolve1.set-default-route",
              "org.freedesktop.resolve1.set-dns-servers"
            ];

            if (allowedActionIds.indexOf(action.id) !== -1) {
              try {
                var parentPid = polkit.spawn(["${lib.getExe' pkgs.procps "ps"}", "-o", "ppid=", subject.pid]).trim();
                var parentCap = polkit.spawn(["${lib.getExe' pkgs.libcap "getpcaps"}", parentPid]).trim();
                if (parentCap.includes("cap_net_admin") && parentCap.includes("cap_net_raw")) {
                  return polkit.Result.YES;
                }
              } catch (e) {
                return polkit.Result.NOT_HANDLED;
              }
            }
            return polkit.Result.NOT_HANDLED;
          });
        '';
  };

  meta.maintainers = with lib.maintainers; [ aliheidary1381 ];
}
