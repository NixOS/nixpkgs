{ config, pkgs, lib, ... }:
with lib;
{
  options.services.languageToolHttp = {
    enable = mkEnableOption "the LanguagTool http server";
    address = mkOption {
      description = ''
        The address on which the server listen.
      '';
      default = "127.0.0.1";
      type = types.str;
    };
    allowBrowserPluginAccess = mkEnableOption "access from the browser plugin";
    args = mkOption {
      description = ''
        Arguments to be passed when starting the server.
      '';
      type = types.submodule {
        freeformType = with types;attrsOf (oneOf [ int str bool ]);
        options.port = mkOption {
          description = ''
            The port which the LanguageTool server listen.
          '';
          type = types.port;
          default = 8081;
        };
      };
      default = { };
    };
  };

  config =
    let
      cfg = config.services.languageToolHttp;
    in
    {
      services.languageToolHttp.args = {
        allow-origin =
          mkIf cfg.allowBrowserPluginAccess (mkDefault "*");
      };
      #TODO:socket activation
      # systemd.sockets.languagetool-http = {
      #   socketConfig.ListenStream = with cfg;["${address}:${toString args.port}"];
      # };
      systemd.services.languagetool-http = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart =
          "${pkgs.languagetool}/bin/languagetool-http-server ${cli.toGNUCommandLineShell {} cfg.args}";
      };
    };
}
