{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.proxy-ns;
  config_path = pkgs.writeTextFile {
    name = "config.json";
    text = builtins.toJSON cfg.config;
  };
in
{
  options.services.proxy-ns = {
    enable = lib.mkEnableOption "proxy-ns";
    settings = lib.mkOption {
      type = configFormat.type;
      description = "";
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
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      description = "path to your config.json";
      default = null;
    };
    package = lib.mkPackageOption pkgs "proxy-ns" { };
  };
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = isNull cfg.config != isNull cfg.configFile;
        message = "can't have both setting and settingFile defined ";
      }
    ];
    environment.systemPackages = [ cfg.package ];
    environment.etc.proxy-ns =
      let
        _enable = {
          enable = true;
          target = "proxy-ns/config.json";
        };
      in
      if !isNull cfg.config then
        {
          source = config_path;
        }
        // _enable
      else if !isNull cfg.configFile then
        {
          source = cfg.configFile;
        }
        // _enable
      else
        { };
    security.wrappers.proxy-ns = {
      source = "${cfg.package}/bin/proxy-ns";
      owner = "root";
      group = "root";
      capabilities = "cap_net_bind_service,cap_fowner,cap_chown,cap_sys_chroot,cap_sys_admin,cap_net_admin=ep";
    };
  };
}
