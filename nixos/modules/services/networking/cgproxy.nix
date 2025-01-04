{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.cgproxy;
  settingsFormat = pkgs.formats.json { };
  settingsFile = settingsFormat.generate "config.json" cfg.settings;
in
{

  options = {
    services.cgproxy = {
      enable = mkEnableOption (lib.mdDoc "cgproxy");

      settings = mkOption {
        description = lib.mdDoc ''
          options priority:
          program_noproxy > program_proxy > cgroup_noproxy > cgroup_proxy
          enable_ipv6 = enable_ipv4 > enable_dns > enable_tcp = enable_udp
          command cgproxy and cgnoproxy always have highest priority

          See: <https://github.com/springzfx/cgproxy/blob/master/readme.md#configuration>
        '';
        default = { };
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {
            port = mkOption {
              type = types.port;
              default = 12345;
              defaultText = literalExpression "12345";
              description = lib.mdDoc "tproxy listenning port";
            };
            program_noproxy = mkOption {
              type = types.listOf types.str;
              default = [ "v2ray" "qv2ray" ];
              defaultText = literalExpression ''[ "v2ray" "qv2ray" ]'';
              description = lib.mdDoc ''
                Programs that won't be proxied.
              '';
            };
            program_proxy = mkOption {
              type = types.listOf types.str;
              default = [ ];
              defaultText = literalExpression "";
              description = lib.mdDoc ''
                Programs that need to be proxied.
              '';
            };
            cgroup_noproxy = mkOption {
              type = types.listOf types.str;
              default = [ "/system.slice/v2ray.service" ];
              defaultText = literalExpression ''"/system.slice/v2ray.service"'';
              description = lib.mdDoc ''
                cgroup array that should not be proxied, `/noproxy.slice` is preserved
              '';
            };

            cgroup_proxy = mkOption {
              type = types.listOf types.str;
              default = [ ];
              defaultText = literalExpression "";
              description = lib.mdDoc ''
                cgroup array that need to be proxied, `/proxy.slice` is preserved
              '';
            };

            enable_gateway = mkOption {
              type = types.bool;
              default = false;
              defaultText = literalExpression "false";
              description = lib.mdDoc ''
                Enable gateway proxy for local devices.
              '';
            };

            enable_dns = mkOption {
              type = types.bool;
              default = true;
              defaultText = literalExpression "true";
              description = lib.mdDoc ''
                Enable dns to go through the proxy.
              '';
            };
          };

        };
      };

      package = mkPackageOptionMD pkgs "cgproxy" { };

    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    environment.etc."cgproxy/config.json".source = settingsFile;

    systemd.packages = [ cfg.package ];

    systemd.services.cgproxy = {
      wantedBy = [ "multi-user.target" ];
    };
  };

  meta.maintainers = with lib.maintainers; [ oluceps ];
}
