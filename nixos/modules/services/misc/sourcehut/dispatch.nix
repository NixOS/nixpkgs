{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sourcehut;
  dcfg = cfg.dispatch;

  inherit (import ./helpers.nix { inherit lib; }) oauthOpts;
in {
  options = {
    services.sourcehut.dispatch = {
      github.oauth = mkOption {
        type = types.submodule oauthOpts;
        default = {};
        description = ''
          Fill this in with a registered GitHub OAuth client id and secret to
          enable GitHub integration.
        '';
      };

      github.extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration for dispatch.sr.ht::github.
        '';
      };
    };
  };

  config = mkIf dcfg.enable {
    assertions =
      [
        {
          assertion = let
            oauthCredentialsEmpty = config: config.oauth.clientId == "" && config.oauth.clientSecret == "";
            oauthCredentialsFilled = config: config.oauth.clientId != "" && config.oauth.clientSecret != "";
          in (oauthCredentialsEmpty dcfg || oauthCredentialsFilled dcfg) &&
             (oauthCredentialsEmpty dcfg.github || oauthCredentialsFilled dcfg.github);
          message = "A client id needs to be paired with a client secret.";
        }
      ];

    users = {
      users = [
        { name = dcfg.user;
          group = dcfg.user;
          description = "dispatch.sr.ht user"; } ];

      groups = [
        { name = dcfg.user; } ];
    };

    systemd.services = {
      "dispatch.sr.ht" = {
        after = [ "postgresql.service" "network.target" ];
        requires = [ "postgresql.service" ];
        wantedBy = [ "multi-user.target" ];

        description = "dispatch.sr.ht website service";

        script = ''
          gunicorn dispatchsrht.app:app \
            -b ${cfg.address}:${toString dcfg.port}
        '';
      };
    };
  };
}
