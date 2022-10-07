{ lib, pkgs, config, ... }:

let
    cfg = config.services.webhook;
    hooksFormat = pkgs.formats.json {};

in {
  options.services.webhook = with lib; {

    enable = mkEnableOption "webhook service";

    package = mkPackageOption pkgs "webhook" { };

    user = mkOption {
      type = types.str;
      default = "webhook";
      description = lib.mdDoc "User under which Webhook runs.";
    };

    group = mkOption {
      type = types.str;
      default = "webhook";
      description = lib.mdDoc "Group under which Webhook runs.";
    };

    listenHost = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc "Which address Webhook should listen to for HTTP.";
    };

    listenPort = mkOption {
      type = types.port;
      default = 8080;
      description = lib.mdDoc "Which port Webhook should listen to for HTTP.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Open the configured ports in the firewall for the Webhook server.
        Preferably the Webhook server is instead put behind a reverse proxy.
      '';
    };

    urlPrefix = mkOption {
      type = types.str;
      default = "hooks";
      description = lib.mdDoc ''
        Url prefix to use for served hooks.
        `http://listen:port/PREFIX/:hook-id`
      '';
    };

    httpMethods = mkOption {
      type = types.listOf types.str;
      default = ["POST"];
      defaultText = literalExpression ''["POST"]'';
      description = lib.mdDoc "Default allowed HTTP methods";
    };

    verbose = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc "Whether to log events or not.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Extra command-line arguments.
        If you want to set CORS headers, you can set [ "-header" "name=value" ]
        to the appropriate CORS headers to passed along with each response.
      '';
    };

    settings = mkOption {
      type = hooksFormat.type;
      default = [];
      example = lib.literalExpression ''
        [
          {
            id = "my-webhook";
            execute-command = pkgs.writeShellScript "handle-my-webhook.sh" '${""}'
              echo "foobar"
            '${""}';
          }
        ]
      '';
      description = lib.mdDoc ''
        The configured hooks for Webhook to serve.
        Here is a collection of hook examples:
        <https://github.com/adnanh/webhook#examples>
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    systemd.services.webhook = {
      description = lib.mdDoc "Webhook Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = let
        args = [
          "-ip" cfg.listenHost
          "-port" cfg.listenPort
          "-http-methods" (lib.strings.concatStringsSep "," cfg.httpMethods)
          "-urlprefix" cfg.urlPrefix
          "-hooks" (hooksFormat.generate "hooks.json" cfg.settings)
        ] ++ lib.optional cfg.verbose "-verbose"
          ++ cfg.extraArgs;
      in rec {
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = cfg.user == "webhook";
        ExecStart = "${cfg.package}/bin/webhook " + (lib.strings.escapeShellArgs args);
        Restart = "on-failure";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listenPort ];
    };

  };

  meta.maintainers = with lib.maintainers; [ pbsds ];
}
