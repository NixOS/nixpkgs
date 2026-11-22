{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.vey-proxy;
in
{
  meta.maintainers = with lib.maintainers; [ zh-jq ];

  options.services.vey-proxy = {
    package = lib.mkPackageOption pkgs "vey-proxy" { };

    instances = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options.configDir = lib.mkOption {
            type = lib.types.path;
            description = ''
              Configuration directory for this instance.
              It is mounted at `/etc/vey-proxy/<name>/` and must contain `main.yaml`.
            '';
          };
        }
      );
      default = { };
      description = ''
        Named vey-proxy instances.
        Each name starts `vey-proxy@<name>.service` with this configuration directory.
      '';
    };
  };

  config = lib.mkIf (cfg.instances != { }) {
    systemd.packages = [ cfg.package ];
    systemd.targets.multi-user.wants = lib.mapAttrsToList (
      name: _: "vey-proxy@${name}.service"
    ) cfg.instances;

    environment.etc = lib.mapAttrs' (
      name: inst:
      lib.nameValuePair "vey-proxy/${name}" {
        source = inst.configDir;
      }
    ) cfg.instances;
  };
}
