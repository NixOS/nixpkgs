{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.languageToolHttp;
  format = pkgs.formats.toml { };
in
{
  options.services.languageToolHttp = {
    enable = mkEnableOption "the LanguagTool http server";
    allowBrowserPluginAccess = mkEnableOption "access from the browser plugin";
    settings = mkOption {
      description = ''
        Contents of the configuration file.
      '';
      inherit (format) type;
      default = { };
    };
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

  config = mkIf cfg.enable {
    services.languageToolHttp.args = {
      allow-origin = mkIf cfg.allowBrowserPluginAccess (mkDefault "*");
      config = builtins.toString (format.generate "LanguageTool.cfg" cfg.settings);
    };
    systemd.services.languagetool-http = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart =
        "${pkgs.languagetool}/bin/languagetool-http-server ${cli.toGNUCommandLineShell {} cfg.args}";
    };
  };
}
