{
  config,
  lib,
  pkgs,
  ...
}:
let
  package = config.services.signond.package.override { plugins = config.services.signond.plugins; };
in
{
  options = {
    services.signond = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable signond, a DBus service
          which performs user authentication on behalf of its clients.
        '';
      };

      package = lib.mkPackageOption pkgs.kdePackages "signond" { };

      plugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs.kdePackages; [
          signon-plugin-oauth2
          signon-kwallet-extension
        ];
        defaultText = lib.literalExpression ''
          with pkgs.kdePackages; [ signon-plugin-oauth2 signon-kwallet-extension ]
        '';
        description = ''
          What plugins to use with the signon daemon.
        '';
      };
    };
  };

  config = lib.mkIf config.services.signond.enable {
    services.dbus.packages = [ package ];
    environment.systemPackages = [
      (lib.hiPrio package)
      pkgs.kdePackages.signon-ui
    ];
  };
}
