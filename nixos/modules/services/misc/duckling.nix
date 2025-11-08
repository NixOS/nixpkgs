{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.duckling;
in
{
  options = {
    services.duckling = {
      enable = lib.mkEnableOption "duckling";

      port = lib.mkOption {
        type = lib.types.port;
        default = 8080;
        description = ''
          Port on which duckling will run.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.duckling = {
      description = "Duckling server service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        PORT = builtins.toString cfg.port;
      };

      serviceConfig = {
        ExecStart = "${pkgs.haskellPackages.duckling}/bin/duckling-example-exe --no-access-log --no-error-log";
        Restart = "always";
        DynamicUser = true;
      };
    };
  };
}
