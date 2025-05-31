{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.librechat;
  format = pkgs.formats.yaml { };
  configFile = format.generate "librechat.yaml" cfg.settings;
  # Thanks to https://github.com/nix-community/home-manager/blob/60e4624302d956fe94d3f7d96a560d14d70591b9/modules/lib/shell.nix :)
  export = n: v: ''export ${n}="${builtins.toString v}"'';
  exportAll = vars: lib.concatStringsSep "\n" (lib.mapAttrsToList export vars);
  exportCredentials = n: _: ''export ${n}="$(${pkgs.systemd}/bin/systemd-creds cat ${n}_FILE)"'';
  exportAllCredentials = vars: lib.concatStringsSep "\n" (lib.mapAttrsToList exportCredentials vars);
  transformCredential = n: v: "${n}_FILE:${v}";
  getLoadCredentialList = lib.mapAttrsToList transformCredential cfg.credentials;
in
{
  options.services.librechat = {
    enable = lib.mkEnableOption "the LibreChat server";
    package = lib.mkPackageOption pkgs "librechat" { };
    openFirewall = lib.mkEnableOption null // {
      description = "Whether to open the port in the firewall.";
    };
    logDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/librechat";
      example = "/persist/librechat";
      description = "Absolute path for where the LibreChat server will use as its log directory.";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3080;
      example = 2309;
      description = "The value that will be passed to the PORT environment variable, telling LibreChat what to listen on.";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "librechat";
      example = "alice";
      description = "The user to run the service as.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "librechat";
      example = "users";
      description = "The group to run the service as.";
    };
    credentials = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = {
        CREDS_KEY = /run/secrets/creds_key;
      };
      description = "Environment variables which are loaded from the contents of files at a file paths, mainly used for secrets. See https://www.librechat.ai/docs/configuration/dotenv for a full list.";
    };
    env = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          path
          int
          float
        ]);
      example = {
        ALLOW_REGISTRATION = "true";
        HOST = "0.0.0.0";
        CONSOLE_JSON_STRING_LENGTH = 255;
      };
      default = { };
      description = "Environment variables that will be set for the service. See https://www.librechat.ai/docs/configuration/dotenv for a full list.";
    };
    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
      };
      default = { };
      example = # nix
        ''
          {
            version = "1.0.8";
            cache = true;
            interface = {
              privacyPolicy = {
                externalUrl = "https://librechat.ai/privacy-policy";
                openNewTab = true;
              };
            };
            endpoints = {
              custom = [
                {
                  name = "OpenRouter";
                  # Note that the following $ should be escaped with a backslash, not '''
                  apiKey = "''${OPENROUTER_KEY}";
                  baseURL = "https://openrouter.ai/api/v1";
                  models = {
                    default = ["meta-llama/llama-3-70b-instruct"];
                    fetch = true;
                  };
                  titleConvo = true;
                  titleModule = "meta-llama/llama-3-70b-instruct";
                  dropParams = ["stop"];
                  modelDisplayLabel = "OpenRouter";
                }
              ];
            };
          }
        '';
      description = "A free-form attribute set that will be written to librechat.yaml. You can use environment variables by wrapping them in \${}. Take care to escape the \$ character.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.env ? PORT -> cfg.port == cfg.env.PORT;
        message = "`services.librechat.port` and `services.librechat.env.PORT` must be set to equal values.";
      }
    ];
    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.port;
    systemd.tmpfiles.settings."10-librechat"."${cfg.logDir}".d = {
      mode = "0755";
      inherit (cfg) user group;
    };
    systemd.services.librechat = {
      wantedBy = [ "multi-user.target" ];
      after = [ "tmpfiles.target" ];
      description = "Open-source app for all your AI conversations, fully customizable and compatible with any AI provider";
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        LoadCredential = getLoadCredentialList;
      };
      script = # sh
        ''
          cd ${cfg.logDir}
          export CONFIG_PATH=${configFile}

          ${exportAll cfg.env}
          ${exportAllCredentials cfg.credentials}
          ${lib.getExe cfg.package}
        '';
    };
    users.users.librechat = lib.mkIf (cfg.user == "librechat") {
      name = "librechat";
      isSystemUser = true;
      group = "librechat";
      description = "LibreChat server user";
    };
    users.groups.librechat = lib.mkIf (cfg.user == "librechat") { };
  };

  meta.maintainers = [
    lib.maintainers.rrvsh
  ];
}
