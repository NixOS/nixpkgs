{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.eduvpn;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    mkDefault
    mkIf
    types
    optionals
    ;
in
{
  options.programs.eduvpn = {
    enable = mkEnableOption "the eduVPN client";
    package = mkPackageOption pkgs "eduvpn-client" { };
    openvpn = mkOption {
      description = "OpenVPN support for eduVPN ('Institute Access')";
      default = { };
      type = types.submodule {
        options = {
          enable = mkEnableOption "OpenVPN support for eduVPN";
          package = mkPackageOption pkgs "networkmanager-openvpn" { };
        };
      };
    };
    wireguard = mkOption {
      description = "Wireguard support for eduVPN ('Secure Internet')";
      default = { };
      type = types.submodule {
        options = {
          enable = mkEnableOption "Wireguard support for eduVPN";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    networking.firewall = mkIf cfg.wireguard.enable {
      checkReversePath = false;
    };
    programs.openvpn3.enable = cfg.openvpn.enable;
    networking.networkmanager.plugins = optionals cfg.openvpn.enable [ cfg.openvpn.package ];

    assertions = [
      {
        assertion = cfg.enable -> config.networking.networkmanager.enable;
        message = "To enable eduVPN, your system must use NetworkManager!";
      }
    ];
  };
}
