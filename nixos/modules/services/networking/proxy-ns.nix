{ config, lib, pkgs, ... }:
let

  cfg = config.services.proxy-ns;
  config_path = pkgs.writeTextFile {
    name = "config.json";
    text = builtins.toJSON cfg.config;
  };

  _getType = value: with lib; if isBool value then types.bool else types.str;
  _mkOpt = value: lib.mkOption { type = _getType value; default = value; };
  options = lib.attrsets.mapAttrs (lhs: _mkOpt) {
    tun_name = "default";
    tun_ip = "10.0.0.1/24";
    tun_ip6 = "fc00::1/7";
    username = "";
    password = "";
    fake_dns = true;
    fake_network = "240.0.0.0/4";
    dns_server = "9.9.9.9";
  };
  configType = with lib.types; attrsOf ( options);
in
{
  options.services.proxy-ns = {
    enable = lib.mkEnableOption "proxy-ns";
    config = lib.mkOption { type = lib.types.nullOr configType; description = ""; };
    configFile = lib.mkOption { type = lib.types.nullOr lib.types.path; description = "path to your config.json"; default = null; };
    package = lib.mkPackageOption pkgs "proxy-ns" { };
  };
  config =
    lib.mkIf cfg.enable {
      assertions = [{ assertion = isNull cfg.config != isNull cfg.configFile; message = "can't have both setting and settingFile defined "; }];
      environment.systemPackages = [ cfg.package ];
      environment.etc.proxy-ns =
        if ! isNull cfg.config then {
          enable = true;
          source = config_path;
        } else
          if ! isNull cfg.configFile then {
            enable = true;
            source = cfg.configFile;
          } else { };
      security.wrappers.proxy-ns = {
        source = "${cfg.package}/bin/proxy-ns";
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_fowner,cap_chown,cap_sys_chroot,cap_sys_admin,cap_net_admin=ep";
      };
    };
}
