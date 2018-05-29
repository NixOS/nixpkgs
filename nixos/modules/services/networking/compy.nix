{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.compy;
  toString = x: if x == false then "0" else builtins.toString x;
in {
  options = {
    services.compy = {
      enable = mkEnableOption "Compy the HTTP/HTTPS compression proxy.";
      user = mkOption {
        type = types.string;
        default = "compy";
        description = "User account under which compy runs.";
      };
      group = mkOption {
        type = types.string;
        default = "compy";
        description = "Group account under which compy runs.";
      };

      host = mkOption {
        type = types.string;
        default = ":9999";
        description = "host:port";
      };
      cert = mkOption {
        type = types.string;
        default = "";
        description = "proxy cert path.";
      };
      key = mkOption {
        type = types.string;
        default = "";
        description = "proxy cert key path.";
      };
      ca = mkOption {
        type = types.string;
        default = "";
        description = "CA path.";
      };
      cakey = mkOption {
        type = types.string;
        default = "";
        description = "CA key path.";
      };
      login = mkOption {
        type = types.string;
        default = "";
        description = "proxy user name.";
      };
      passwordFile = mkOption {
        type = types.str;
        default = "";
        description = "File that containts password";
      };
      brotli = mkOption {
        type = types.int;
        default = 6;
        description = "Brotli compression level (0-11).";
      };
      jpeg = mkOption {
        type = types.int;
        default = 50;
        description = "jpeg quality (1-100, 0 to disable).";
      };
      gif = mkOption {
        type = types.bool;
        default = true;
        description = "transcode gifs into static images.";
      };
      gzip = mkOption {
        type = types.int;
        default = 6;
        description = "gzip compression level (0-9).";
      };
      png = mkOption {
        type = types.bool;
        default = true;
        description = "transcode png.";
      };
      minify = mkOption {
        type = types.bool;
        default = false;
        description = "minify css/html/js - WARNING: tends to break the web.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers = optionalAttrs (cfg.user == "compy") {
      compy = {
        description = "Compy user";
        inherit (cfg) group;
      };
    };
    users.extraGroups = optionalAttrs (cfg.group == "compy") {
      compy = {};
    };

    systemd.services.compy = {
      description = "HTTP/HTTPS compression proxy";
      after = [ "network.target" "nss-lookup.target" ];
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.compy}/bin/compy -host=${cfg.host} -cert=${cfg.cert} -key=${cfg.key} -ca=${cfg.ca} -cakey=${cfg.cakey} -user=${cfg.login} -pass=${optionalString (cfg.passwordFile != "") "$(cat \"${cfg.passwordFile}\")"} -brotli=${toString cfg.brotli} -jpeg=${toString cfg.jpeg} -gif=${toString cfg.gif} -gzip=${toString cfg.gzip} -png=${toString cfg.png} -minify=${toString cfg.minify}";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };

  meta.maintainers = with maintainers; [ gnidorah ];
}
