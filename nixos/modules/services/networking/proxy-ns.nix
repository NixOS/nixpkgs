{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.proxy-ns;
  configFormat = pkgs.formats.json { };
in
{
  options.services.proxy-ns = {
    enable = lib.mkEnableOption "proxy-ns";
    settings = lib.mkOption {
      description = ''
        The default setting.

        See <https://github.com/OkamiW/proxy-ns>.
      '';
      type = configFormat.type;
      example = {
        tun_name = "default";
        tun_ip = "10.0.0.1/24";
        socks5_address = "127.0.0.1:1080";
        tun_ip6 = "fc00::1/7";
        username = "";
        password = "";
        fake_dns = true;
        fake_network = "240.0.0.0/4";
        dns_server = "9.9.9.9";
      };
    };
    package = lib.mkPackageOption pkgs "proxy-ns" { };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        message = "can't have both setting and settingFile defined ";
      }
    ];
    environment.systemPackages = [ cfg.package ];
    environment.etc.proxy-ns =
      if !isNull cfg.config then
        {
          source = builtins.toJSON cfg.config;
        }
      else
        { };
    security.wrappers.proxy-ns = {
      source = "${cfg.package}/bin/proxy-ns";
      owner = "root";
      group = "root";
      capabilities = "cap_sys_admin,cap_net_admin,cap_net_bind_service,cap_sys_chroot,cap_chown=ep";
    };
  };
}
