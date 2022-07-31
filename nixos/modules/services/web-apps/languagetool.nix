{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.languageToolHttp;
  format = pkgs.formats.toml { };
  confDoc = "See languagetool-http-server --help for further details";
in
{
  options.services.languageToolHttp = {
    enable = mkEnableOption "the LanguagTool http server";
    allowBrowserPluginAccess = mkEnableOption "access from the browser plugin";
    public = mkEnableOption ''
      access this server from anywhere, not only localhost.
      Note that it is reccomended to run this behind
      a HTTPS reverse proxy like apache or ngnix
    '';
    settings = mkOption {
      description = ''
        Contents of the configuration file. ${confDoc}
      '';
      inherit (format) type;
      default = { };
    };
    args = mkOption {
      description = ''
        Arguments to be passed when starting the server. ${confDoc}
      '';
      type = types.submodule {
        freeformType = with types;attrsOf (oneOf [ int str path ]);
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
      config = format.generate "LanguageTool.cfg" cfg.settings;
      public = mkIf cfg.public "";
    };
    systemd.services.languagetool-http = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "LanguageTool HTTP server";
      serviceConfig = {
        User = "langtool";
        Group = "langtool";
        Type = "simple";
        ExecStart = "${pkgs.languagetool}/bin/languagetool-http-server ${cli.toGNUCommandLineShell {} cfg.args}";
        PrivateTmp = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        ProtectClock = true;
        PrivateNetwork = !cfg.public;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
      };
    };
    users.users.langtool = {
      isSystemUser = true;
      group = "langtool";
    };
    users.groups.langtool = { };
  };
}
