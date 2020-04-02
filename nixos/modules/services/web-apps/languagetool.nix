{config, pkgs, lib, ...}:
with lib;
{
  options.services.languageToolHttp = {
    enable = mkEnableOption "the LanguagTool http server";
    port = mkOption {
      description = ''
        The port which the LanguageTool server listen.
      '';
      type = types.port;
      default = 8081;
    };
    address = mkOption{
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
      #TODO: GNU commandline type
      type = with types;attrsOf (oneOf [ int str bool ]);
      default = { };
    };
  };
  
  config = 
    let
      cfg = config.services.languageToolHttp;
    in {
      services.languageToolHttp.args = {
        allow-origin = 
        mkIf cfg.allowBrowserPluginAccess (mkDefault "*");
        port = mkDefault cfg.port;
      };
      #TODO:socket activation
      # systemd.sockets.languagetool-http = {
      #   socketConfig.ListenStream = with cfg;["${address}:${toString port}"];
      # };
      systemd.services.languagetool-http = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig.ExecStart = 
          "${pkgs.languagetool}/bin/languagetool-http-server ${cli.toGNUCommandLineShell {} cfg.args}";
      };
    };
}