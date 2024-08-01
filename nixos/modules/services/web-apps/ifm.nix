{ config, lib, pkgs, ...}:
let
  cfg = config.services.ifm;

  version = "4.0.2";
  src = pkgs.fetchurl {
    url = "https://github.com/misterunknown/ifm/releases/download/v${version}/cdn.ifm.php";
    hash = "sha256-37WbRM6D7JGmd//06zMhxMGIh8ioY8vRUmxX4OHgqBE=";
  };

  php = pkgs.php83;
in {
  options.services.ifm = {
    enable = lib.mkEnableOption ''
      Improved file manager, a single-file web-based filemanager

      Lightweight and minimal, served using PHP's built-in server
  '';

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory to serve throught the file managing service";
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address on which the service is listening";
      example = "0.0.0.0";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9090;
      description = "Port on which to serve the IFM service";
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = {};
      description = ''
        Configuration of the IFM service.

        See [the documentation](https://github.com/misterunknown/ifm/wiki/Configuration)
        for available options and default values.
      '';
      example = {
        IFM_GUI_SHOWPATH = 0;
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ifm = {
      description = "Improved file manager, a single-file web based filemanager";

      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        IFM_ROOT_DIR = "/data";
      } // (builtins.mapAttrs (_: val: toString val) cfg.settings);

      script = ''
        mkdir -p /tmp/ifm
        ln -s ${src} /tmp/ifm/index.php
        ${lib.getExe php} -S ${cfg.listenAddress}:${builtins.toString cfg.port} -t /tmp/ifm
      '';

      serviceConfig = {
        DynamicUser = true;
        User = "ifm";
        StandardOutput = "journal";
        BindPaths = "${cfg.dataDir}:/data";
        PrivateTmp = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ litchipi ];
}
