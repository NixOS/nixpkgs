{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.zeronet;
  dataDir = "/var/lib/zeronet";
  configFile = pkgs.writeText "zeronet.conf" (
    lib.generators.toINI { } (lib.recursiveUpdate defaultSettings cfg.settings)
  );

  defaultSettings = {
    global = {
      data_dir = dataDir;
      log_dir = dataDir;
      ui_port = cfg.port;
      fileserver_port = cfg.fileserverPort;
      tor =
        if !cfg.tor then
          "disable"
        else if cfg.torAlways then
          "always"
        else
          "enable";
    };
  };
in
{
  options.services.zeronet = {
    enable = lib.mkEnableOption "zeronet";

    package = lib.mkPackageOption pkgs "zeronet" { };

    settings = lib.mkOption {
      type =
        lib.types.attrsOf (
          lib.types.attrsOf (lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.bool
            (lib.types.listOf lib.types.str)
          ])
        );
      default = { };
      example = lib.literalExpression "{ global.tor = enable; }";

      description = ''
        {file}`zeronet.conf` configuration. Refer to
        <https://zeronet.readthedocs.io/en/latest/faq/#is-it-possible-to-use-a-configuration-file>
        for details on supported values;
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 43110;
      description = "Optional zeronet web UI port.";
    };

    fileserverPort = lib.mkOption {
      # Not lib.optional: when absent zeronet tries to write one to the
      # read-only config file and crashes
      type = lib.types.port;
      default = 12261;
      description = "Zeronet fileserver port.";
    };

    tor = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use TOR for zeronet traffic where possible.";
    };

    torAlways = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use TOR for all zeronet traffic.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tor = lib.mkIf cfg.tor {
      enable = true;
      controlPort = 9051;

      extraConfig = ''
        CacheDirectoryGroupReadable 1
        CookieAuthentication 1
        CookieAuthFileGroupReadable 1
      '';
    };

    systemd.services.zeronet = {
      description = "zeronet";
      after = [ "network.target" ] ++ lib.optional cfg.tor "tor.service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "zeronet";
        DynamicUser = true;
        StateDirectory = "zeronet";
        SupplementaryGroups = lib.mkIf cfg.tor [ "tor" ];
        ExecStart = "${cfg.package}/bin/zeronet --config_file ${configFile}";
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [
      "services"
      "zeronet"
      "dataDir"
    ] "Zeronet will store data by default in /var/lib/zeronet")
    (lib.mkRemovedOptionModule [
      "services"
      "zeronet"
      "logDir"
    ] "Zeronet will log by default in /var/lib/zeronet")
  ];

  meta.maintainers = with lib.maintainers; [ Madouura ];
}
