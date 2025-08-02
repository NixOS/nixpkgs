{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.opkssh;
  opkssh = pkgs.opkssh;

  providerFile = pkgs.writeText "opkssh-providers" (
    concatStringsSep "\n" (
      mapAttrsToList (
        name: provider: "${provider.issuer} ${provider.clientId} ${provider.lifetime}"
      ) cfg.providers
    )
  );

  authIdFile = pkgs.writeText "opkssh-auth-id" (
    concatStringsSep "\n" (
      map (auth: "${auth.user} ${auth.principal} ${auth.issuer}") cfg.authorizations
    )
  );
in
{
  options.services.opkssh = {
    enable = mkEnableOption "OpenID Connect SSH authentication";

    package = mkPackageOption pkgs "opkssh" { };

    user = mkOption {
      type = types.str;
      default = "opksshuser";
      description = "System user for running opkssh";
    };

    group = mkOption {
      type = types.str;
      default = "opksshuser";
      description = "System group for opkssh";
    };

    providers = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            issuer = mkOption {
              type = types.str;
              description = "Issuer URI";
              example = "https://accounts.google.com";
            };

            clientId = mkOption {
              type = types.str;
              description = "OAuth client ID";
            };

            lifetime = mkOption {
              type = types.str;
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
      };
      description = "OpenID Connect providers configuration";
      example = literalExpression ''
        {
          google = {
            issuer = "https://accounts.google.com";
            clientId = "206584157355-7cbe4s640tvm7naoludob4ut1emii7sf.apps.googleusercontent.com";
            lifetime = "24h";
          };
          github = {
            issuer = "https://token.actions.githubusercontent.com";
            clientId = "github";
            lifetime = "oidc";
          };
        }
      '';
    };

    authorizations = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            user = mkOption {
              type = types.str;
              description = "Linux user to authorize";
            };

            principal = mkOption {
              type = types.str;
              description = "Principal identifier (email, repo, etc.)";
            };

            issuer = mkOption {
              type = types.str;
              description = "Issuer URI";
            };
          };
        }
      );
      default = [ ];
      description = "User authorization mappings";
      example = literalExpression ''
        [
          {
            user = "github";
            principal = "example@gmail.com";
            issuer = "https://accounts.google.com";
          }
          {
            user = "github";
            principal = "repo:NixOs/nixpkgs:environment:production";
            issuer = "https://token.actions.githubusercontent.com";
          }
        ]
      '';
    };
  };

  config = mkIf cfg.enable {
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
}
