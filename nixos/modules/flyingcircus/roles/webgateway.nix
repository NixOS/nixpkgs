{ config, lib, pkgs, ... }: with lib;

{

  options = {

    flyingcircus.roles.webgateway = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus webgateway role.";
      };

    };

  };

  config = mkIf config.flyingcircus.roles.webgateway.enable {
    flyingcircus.roles.nginx.enable = true;
    flyingcircus.roles.haproxy.enable = true;
  };
}
