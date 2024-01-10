{ config, lib, pkgs, ... }: let

  cfg = config.services.ollama;

in {

  options = {
    services.ollama = {
      enable = lib.mkEnableOption (
        lib.mdDoc "Server for local large language models"
      );
      package = lib.mkPackageOption pkgs "ollama" { };
    };
  };

  config = lib.mkIf cfg.enable {

    systemd = {
      services.ollama = {
        wantedBy = [ "multi-user.target" ];
        description = "Server for local large language models";
        after = [ "network.target" ];
        environment = {
          HOME = "%S/ollama";
          OLLAMA_MODELS = "%S/ollama/models";
        };
        serviceConfig = {
          ExecStart = "${lib.getExe cfg.package} serve";
          WorkingDirectory = "/var/lib/ollama";
          StateDirectory = [ "ollama" ];
          DynamicUser = true;
        };
      };
    };

    environment.systemPackages = [ cfg.package ];

  };

  meta.maintainers = with lib.maintainers; [ onny ];

}
