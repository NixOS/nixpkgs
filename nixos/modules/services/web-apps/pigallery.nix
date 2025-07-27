{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.pigallery2;

in
{

  options.services.pigallery2 = {
    enable = mkEnableOption "pigallery2";

    hostName = mkOption {
      type = types.str;
      description = "FQDN for the pigallery2 instance.";
    };
    package = mkOption {
      type = types.package;
      description = "Which package to use for the pigallery2 instance.";
      default = pkgs.pigallery2;
    };
    port = mkOption {
      type = types.int;
      default = 3000;
      example = 80;
      description = ''
        Port to listen on.
      '';
    };

    # Implementation
    config = mkIf cfg.enable {

      # TODO

    };
  };
}
