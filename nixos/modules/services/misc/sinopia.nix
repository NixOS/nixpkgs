{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sinopia;

  configFile = pkgs.writeText "sinopia.json" (builtins.toJSON ({
    storage = cfg.storagePath;
    uplinks.npmjs.url = "https://registry.npmjs.org/";
    auth = optionalAttrs (cfg.auth != null) {
      htpasswd = {
        file = cfg.auth;
        max_users = -1;
      };
    };
    web.enable = false;
    packages = {
      "@*/\*" = {
        allow_access = "\$" + cfg.allowAccess;
        allow_publish = "\$" + cfg.allowPublish;
      };
      "*" = {
        allow_access = "\$" + cfg.allowAccess;
        allow_publish = "\$" + cfg.allowPublish;
        proxy = "npmjs";
      };
    };
    logs = [{type = "stdout"; format = "pretty"; level = "http";}];
  } // cfg.extraConfig));
in {
  options.services.sinopia = {
    enable = mkEnableOption "Whether to enable sinopia npm registry service.";

    host = mkOption {
      description = "Sinopia listening host.";
      default = "localhost";
      type = types.str;
    };

    port = mkOption {
      description = "Sinopia listening port.";
      default = 4873;
      type = types.int;
    };

    auth = mkOption {
      description = "Sinopia htaccess file.";
      default = null;
      type = types.nullOr types.path;
    };

    allowAccess = mkOption {
      description = "Users who can access packages.";
      default = "all";
      type = types.enum ["all" "anonymous" "authenticated"];
    };

    allowPublish = mkOption {
      description = "Sinopia roles that can publish packages.";
      default = "authenticated";
      type = types.enum ["all" "anonymous" "authenticated"];
    };

    storagePath = mkOption {
      description = "Sinopia storage path.";
      default = "/var/lib/sinopia/storage";
      type = types.path;
    };

    runPath = mkOption {
      description = "Sinopia working directory.";
      default = "/var/lib/sinopia";
      type = types.path;
    };

    extraConfig = mkOption {
      description = "Sinopia extra configuration file.";
      default = {};
      type = types.attrs;
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sinopia = {
      description = "Sinopia Npm Registry Service.";
      wantedBy = ["multi-user.target"];
      after = ["network.target"];
      serviceConfig = {
        ExecStart =
          "${pkgs.nodePackages.sinopia}/bin/sinopia --config ${configFile}";
        User = "sinopia";
        WorkingDirectory = cfg.runPath;
      };
    };

    users.extraUsers.sinopia = {
      uid = config.ids.uids.sinopia;
      description = "Sinopia user";
      createHome = true;
      home = cfg.runPath;
    };
  };
}
