{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.go-neb;

  configFile = pkgs.writeText "config.yml" (builtins.toJSON cfg.config);
in {
  options.services.go-neb = {
    enable = mkEnableOption "Extensible matrix bot written in Go";

    bindAddress = mkOption {
      type = types.str;
      description = "Port (and optionally address) to listen on.";
      default = ":4050";
    };

    baseUrl = mkOption {
      type = types.str;
      description = "Public-facing endpoint that can receive webhooks.";
    };

    config = mkOption {
      type = types.uniq types.attrs;
      description = ''
        Your <filename>config.yaml</filename> as a Nix attribute set.
        See <link xlink:href="https://github.com/matrix-org/go-neb/blob/master/config.sample.yaml">config.sample.yaml</link>
        for possible options.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.go-neb = {
      description = "Extensible matrix bot written in Go";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        BASE_URL = cfg.baseUrl;
        BIND_ADDRESS = cfg.bindAddress;
        CONFIG_FILE = configFile;
      };

      serviceConfig = {
        ExecStart = "${pkgs.go-neb}/bin/go-neb";
        DynamicUser = true;
      };
    };
  };

  meta.maintainers = with maintainers; [ hexa maralorn ];
}
