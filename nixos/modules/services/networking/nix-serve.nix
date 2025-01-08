{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.nix-serve;
in
{
  options = {
    services.nix-serve = {
      enable = lib.mkEnableOption "nix-serve, the standalone Nix binary cache server";

      port = lib.mkOption {
        type = lib.types.port;
        default = 5000;
        description = ''
          Port number where nix-serve will listen on.
        '';
      };

      bindAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = ''
          IP address where nix-serve will bind its listening socket.
        '';
      };

      package = lib.mkPackageOption pkgs "nix-serve" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open ports in the firewall for nix-serve.";
      };

      secretKeyFile = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          The path to the file used for signing derivation data.
          Generate with:

          ```
          nix-store --generate-binary-cache-key key-name secret-key-file public-key-file
          ```

          For more details see {manpage}`nix-store(1)`.
        '';
      };

      extraParams = lib.mkOption {
        type = lib.types.separatedString " ";
        default = "";
        description = ''
          Extra command line parameters for nix-serve.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    nix.settings = lib.optionalAttrs (lib.versionAtLeast config.nix.package.version "2.4") {
      extra-allowed-users = [ "nix-serve" ];
    };

    systemd.services.nix-serve = {
      description = "nix-serve binary cache server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [
        config.nix.package.out
        pkgs.bzip2.bin
      ];
      environment.NIX_REMOTE = "daemon";

      script = ''
        ${lib.optionalString (cfg.secretKeyFile != null) ''
          export NIX_SECRET_KEY_FILE="$CREDENTIALS_DIRECTORY/NIX_SECRET_KEY_FILE"
        ''}
        exec ${cfg.package}/bin/nix-serve --listen ${cfg.bindAddress}:${toString cfg.port} ${cfg.extraParams}
      '';

      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        User = "nix-serve";
        Group = "nix-serve";
        DynamicUser = true;
        LoadCredential = lib.optionalString (
          cfg.secretKeyFile != null
        ) "NIX_SECRET_KEY_FILE:${cfg.secretKeyFile}";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
