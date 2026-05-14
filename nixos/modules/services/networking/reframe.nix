{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.reframe;
  iniFmt = pkgs.formats.ini { };
in
{
  options.services.reframe = {
    enable = lib.mkEnableOption "DRM/KMS based remote desktop for Linux that supports Wayland/NVIDIA/headless/login…";
    package = lib.mkPackageOption pkgs "reframe" { };
    configs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            reframe = {
              card = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Select monitor via DRM card. All available cards and connectors can be found in `/sys/class/drm/`.";
                example = "card0";
              };
              connector = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Select monitor via connector. All available cards and connectors can be found in `/sys/class/drm/`.";
                example = "eDP-1";
              };
              rotation = lib.mkOption {
                type = lib.types.enum [
                  0
                  90
                  180
                  270
                ];
                default = 0;
                description = ''
                  This is the angle you rotate the monitor, not the angle of display content relative to the monitor!
                  Valid angles are clockwise `0`, `90`, `180`, `270`.
                '';
              };
              desktop-width = lib.mkOption {
                type = lib.types.int;
                default = 0;
                description = ''
                  If you have more than 1 monitor, set those values to the logical size of the whole virtual desktop.
                  You can get those value by finding the pointer position of the right most and bottom most border of your monitors.
                '';
              };
              desktop-height = lib.mkOption {
                type = lib.types.int;
                default = 0;
                description = ''
                  If you have more than 1 monitor, set those values to the logical size of the whole virtual desktop.
                  You can get those value by finding the pointer position of the right most and bottom most border of your monitors.
                '';
              };
              monitor-x = lib.mkOption {
                type = lib.types.int;
                default = 0;
                description = ''
                  If you have more than 1 monitor, set those values to the logical position of the top left corner of your selected monitor.
                '';
              };
              monitor-y = lib.mkOption {
                type = lib.types.int;
                default = 0;
                description = ''
                  If you have more than 1 monitor, set those values to the logical position of the top left corner of your selected monitor.
                '';
              };
              default-width = lib.mkOption {
                type = lib.types.int;
                default = 0;
                description = ''
                  If your client does not support resizing, use those to force a size. Empty or `0` means monitor size.
                '';
              };
              default-height = lib.mkOption {
                type = lib.types.int;
                default = 0;
                description = ''
                  If your client does not support resizing, use those to force a size. Empty or `0` means monitor size.
                '';
              };
              resize = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = ''
                  Set to `false` to prohibit client resizing.
                '';
              };
              cursor = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = ''
                  Set to `false` to ignore DRM cursor plane.
                '';
              };
              wakeup = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = ''
                  Set to `false` if you already disabled automatic screen blank.
                '';
              };
              damage = lib.mkOption {
                type = lib.types.enum [
                  ""
                  "cpu"
                  "gpu"
                ];
                default = "cpu";
                description = ''
                  Set to `gpu` to use GPU damage region detection, which may be more efficiency but may cause artifacts depending on GPU vendors.
                  Set to `cpu` to use CPU damage region detection if you get bugs with `gpu`.
                  Empty to disable damage region detection, which may require higher network bandwidth.
                '';
              };
              fps = lib.mkOption {
                type = lib.types.int;
                default = 30;
              };
            };
            vnc = {
              ip = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  Empty means accept all incoming connections.
                '';
              };
              port = lib.mkOption {
                type = lib.types.port;
                default = 5933;
              };
              password = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  Empty means no password.
                '';
              };
              type = lib.mkOption {
                type = lib.types.enum [
                  "libvncserver"
                  "neatvnc"
                ];
                default = "libvncserver";
                description = ''
                  Set to `neatvnc` to prefer neatvnc, which provides more efficient encoding methods but maybe more unstable.
                '';
              };
            };
          };
        }
      );
      default = { };
      description = "Configurations for ReFrame";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.tmpfiles.packages = [ cfg.package ];
    users.users.reframe = {
      isSystemUser = true;
      group = "reframe";
      description = "ReFrame Remote Desktop";
    };
    users.groups.reframe = { };
    environment.etc = lib.mapAttrs' (
      name: value:
      lib.nameValuePair "reframe/${name}.conf" {
        mode = "0644";
        user = "root";
        group = "root";
        source = iniFmt.generate "${name}.conf" value;
      }
    ) cfg.configs;
    systemd.services = lib.mapAttrs' (
      name: _:
      lib.nameValuePair "reframe-server@${name}" {
        wantedBy = [ "multi-user.target" ];
      }
    ) cfg.configs;
  };

  meta.maintainers = with lib.maintainers; [
    bitbloxhub
  ];
}
