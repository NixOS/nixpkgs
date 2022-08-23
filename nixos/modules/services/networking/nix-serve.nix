{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.nix-serve;
in
{
  options = {
    services.nix-serve = {
      enable = mkEnableOption "nix-serve, the standalone Nix binary cache server";

      port = mkOption {
        type = types.port;
        default = 5000;
        description = lib.mdDoc ''
          Port number where nix-serve will listen on.
        '';
      };

      bindAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc ''
          IP address where nix-serve will bind its listening socket.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Open ports in the firewall for nix-serve.";
      };

      secretKeyFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          The path to the file used for signing derivation data.
          Generate with:

          <programlisting>
          nix-store --generate-binary-cache-key key-name secret-key-file public-key-file
          </programlisting>

          For more details see <citerefentry><refentrytitle>nix-store</refentrytitle><manvolnum>1</manvolnum></citerefentry>.
        '';
      };

      extraParams = mkOption {
        type = types.separatedString " ";
        default = "";
        description = lib.mdDoc ''
          Extra command line parameters for nix-serve.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nix-serve = {
      description = "nix-serve binary cache server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = [ config.nix.package.out pkgs.bzip2.bin ];
      environment.NIX_REMOTE = "daemon";

      script = ''
        ${lib.optionalString (cfg.secretKeyFile != null) ''
          export NIX_SECRET_KEY_FILE="$CREDENTIALS_DIRECTORY/NIX_SECRET_KEY_FILE"
        ''}
        exec ${pkgs.nix-serve}/bin/nix-serve --listen ${cfg.bindAddress}:${toString cfg.port} ${cfg.extraParams}
      '';

      serviceConfig = {
        Restart = "always";
        RestartSec = "5s";
        User = "nix-serve";
        Group = "nix-serve";
        DynamicUser = true;
        LoadCredential = lib.optionalString (cfg.secretKeyFile != null)
          "NIX_SECRET_KEY_FILE:${cfg.secretKeyFile}";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
