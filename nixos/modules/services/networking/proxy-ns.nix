{ config, lib, pkgs, ... }:
let
  mkConfig =
    { tun_name
    , tun_ip
    , socks5_address
    , username ? ""
    , password ? ""
    , fake_dns ? false
    , fake_network ? ""
    , dns_server ? ""
    }@attrs: attrs // { _type = "option"; };

  cfg = config.services.proxy-ns;

  setting_path = pkgs.writeTextFile {
    name = "config.json";
    text = builtins.toJSON cfg.config;
    destination = "/etc/config.json";
  };

in
{
  options.services.proxy-ns = {
    enable = lib.mkEnableOption "proxy-ns";
    config = lib.mkOption { type = lib.type.path; };
    package = lib.mkPackageOption pkgs "proxy-ns";
  };
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [cfg.package];
    security.wrapper.proxy-ns = {
      source = "${cfg.package}/bin/proxy-ns";
      capabilities = "cap_net_bind_service,cap_fowner,cap_chown,cap_sys_chroot,cap_sys_admin,cap_net_admin=ep";
    };
  };
}
