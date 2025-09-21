{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    generators
    literalExpression
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    recursiveUpdate
    types
    ;
  cfg = config.services.zeronet;
  dataDir = "/var/lib/zeronet";
  configFile = pkgs.writeText "zeronet.conf" (
    generators.toINI { } (recursiveUpdate defaultSettings cfg.settings)
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
with lib;
{
  options.services.zeronet = {
    enable = mkEnableOption "zeronet";

    package = mkPackageOption pkgs "zeronet" { };

    settings = mkOption {
      type =
        with types;
        attrsOf (
          attrsOf (oneOf [
            str
            int
            bool
            (listOf str)
          ])
        );
      default = { };
      example = literalExpression "{ global.tor = enable; }";

      description = ''
        {file}`zeronet.conf` configuration. Refer to
        <https://zeronet.readthedocs.io/en/latest/faq/#is-it-possible-to-use-a-configuration-file>
        for details on supported values;
      '';
    };

    port = mkOption {
      type = types.port;
      default = 43110;
      description = "Optional zeronet web UI port.";
    };

    fileserverPort = mkOption {
      # Not optional: when absent zeronet tries to write one to the
      # read-only config file and crashes
      type = types.port;
      default = 12261;
      description = "Zeronet fileserver port.";
    };

    tor = mkOption {
      type = types.bool;
      default = false;
      description = "Use TOR for zeronet traffic where possible.";
    };

    torAlways = mkOption {
      type = types.bool;
      default = false;
      description = "Use TOR for all zeronet traffic.";
    };
  };

  config = mkIf cfg.enable {
    services.tor = mkIf cfg.tor {
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
      after = [ "network.target" ] ++ optional cfg.tor "tor.service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        User = "zeronet";
        DynamicUser = true;
        StateDirectory = "zeronet";
        SupplementaryGroups = mkIf cfg.tor [ "tor" ];
        ExecStart = "${cfg.package}/bin/zeronet --config_file ${configFile}";
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [
      "services"
      "zeronet"
      "dataDir"
    ] "Zeronet will store data by default in /var/lib/zeronet")
    (mkRemovedOptionModule [
      "services"
      "zeronet"
      "logDir"
    ] "Zeronet will log by default in /var/lib/zeronet")
  ];

  meta = {
    inherit (pkgs.zeronet) maintainers;
  };
}
