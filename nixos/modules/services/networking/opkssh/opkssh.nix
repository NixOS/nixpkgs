{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.opkssh;

  providerFile = pkgs.writeText "opkssh-providers" (
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: provider: "${provider.issuer} ${provider.clientId} ${provider.lifetime}"
      ) cfg.providers
    )
  );

  authIdFile = pkgs.writeText "opkssh-auth-id" (
    lib.concatStringsSep "\n" (
      lib.map (auth: "${auth.user} ${auth.principal} ${auth.issuer}") cfg.authorizations
    )
  );
in
{
  options.services.opkssh = {
    enable = lib.mkEnableOption "OpenID Connect SSH authentication";

    package = lib.mkPackageOption pkgs "opkssh" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "opksshuser";
      description = "System user for running opkssh";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "opksshuser";
      description = "System group for opkssh";
    };

    providers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            issuer = lib.mkOption {
              type = lib.types.str;
              description = "Issuer URI";
              example = "https://accounts.google.com";
            };

            clientId = lib.mkOption {
              type = lib.types.str;
              description = "OAuth client ID";
            };

            lifetime = lib.mkOption {
              type = lib.types.enum [
                "12h"
                "24h"
                "48h"
                "1week"
                "oidc"
                "oidc-refreshed"
              ];
              default = "24h";
              description = "Token lifetime";
            };
          };
        }
      );
      default = {
        google = {
          issuer = "https://accounts.google.com";
          clientId = "206584157355-7cbe4s640tvm7naoludob4ut1emii7sf.apps.googleusercontent.com";
          lifetime = "24h";
        };
        microsoft = {
          issuer = "https://login.microsoftonline.com/9188040d-6c67-4c5b-b112-36a304b66dad/v2.0";
          clientId = "096ce0a3-5e72-4da8-9c86-12924b294a01";
          lifetime = "24h";
        };
        github = {
          issuer = "https://token.actions.githubusercontent.com";
          clientId = "github";
          lifetime = "oidc";
        };
      };
      description = "OpenID Connect providers configuration";
    };

    authorizations = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            user = lib.mkOption {
              type = lib.types.str;
              description = "Linux user to authorize";
            };

            principal = lib.mkOption {
              type = lib.types.str;
              description = "Principal identifier (email, repo, etc.)";
            };

            issuer = lib.mkOption {
              type = lib.types.str;
              description = "Issuer URI";
            };
          };
        }
      );
      default = [ ];
      description = "User authorization mappings";
      example = lib.literalExpression ''
        # This example refers to values in the providers example
        # adjust your expressions as necessary
        [
          {
            user = "alice";
            principal = "alice@gmail.com";
            inherit (config.services.opkssh.providers.google) issuer;
          }
          {
            user = "bob";
            principal = "repo:NixOs/nixpkgs:environment:production";
            inherit (config.services.opkssh.providers.github) issuer;
          }
        ];
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups.${cfg.group} = { };
    users.users.${cfg.user} = {
      isSystemUser = true;
      description = "OpenPubkey OpenID Connect SSH User";
      group = cfg.group;
    };

    services.openssh = {
      authorizedKeysCommand = "/run/wrappers/bin/opkssh verify %u %k %t";
      authorizedKeysCommandUser = cfg.user;
    };

    security.wrappers."opkssh" = {
      source = "${cfg.package}/bin/opkssh";
      owner = "root";
      group = "root";
    };

    environment.etc."opk/providers" = {
      mode = "0640";
      user = cfg.user;
      group = cfg.group;
      source = providerFile;
    };

    environment.etc."opk/auth_id" = {
      mode = "0640";
      user = cfg.user;
      group = cfg.group;
      source = authIdFile;
    };
  };

  meta.maintainers = with lib.maintainers; [ datosh ];
}
