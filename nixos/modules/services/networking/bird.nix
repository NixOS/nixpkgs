{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalString
    types
    ;

  cfg = config.services.bird;
  caps = [
    "CAP_NET_ADMIN"
    "CAP_NET_BIND_SERVICE"
    "CAP_NET_RAW"
  ];
in
{
  ###### interface
  options = {
    services.bird = {
      enable = mkEnableOption "BIRD Internet Routing Daemon";
      package = lib.mkPackageOption pkgs "bird3" { };
      config = mkOption {
        type = types.lines;
        description = ''
          BIRD Internet Routing Daemon configuration file.
          <http://bird.network.cz/>
        '';
      };
      autoReload = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether bird should be automatically reloaded when the configuration changes.
        '';
      };
      checkConfig = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether the config should be checked at build time.
          When the config can't be checked during build time, for example when it includes
          other files, either disable this option or use `preCheckConfig` to create
          the included files before checking.
        '';
      };
      preCheckConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          echo "cost 100;" > include.conf
        '';
        description = ''
          Commands to execute before the config file check. The file to be checked will be
          available as `bird.conf` in the current directory.

          Files created with this option will not be available at service runtime, only during
          build time checking.
        '';
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "services" "bird2" ]
      "Use services.bird instead. bird3 is the new default bird package. You can choose to remain with bird2 by setting the service.bird.package option."
    )
    (lib.mkRemovedOptionModule [ "services" "bird6" ] "Use services.bird instead")
  ];

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    environment.etc."bird/bird.conf".source = pkgs.writeTextFile {
      name = "bird";
      text = cfg.config;
      derivationArgs.nativeBuildInputs = lib.optional cfg.checkConfig cfg.package;
      checkPhase = optionalString cfg.checkConfig ''
        ln -s $out bird.conf
        ${cfg.preCheckConfig}
        bird -d -p -c bird.conf || { exit=$?; cat -n bird.conf; exit $exit; }
      '';
    };

    systemd.services.bird = {
      description = "BIRD Internet Routing Daemon";
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = lib.optional cfg.autoReload config.environment.etc."bird/bird.conf".source;
      serviceConfig = {
        Type = "forking";
        Restart = "on-failure";
        User = "bird";
        Group = "bird";
        ExecStart = "${lib.getExe' cfg.package "bird"} -c /etc/bird/bird.conf";
        ExecReload = "${lib.getExe' cfg.package "birdc"} configure";
        ExecStop = "${lib.getExe' cfg.package "birdc"} down";
        RuntimeDirectory = "bird";
        CapabilityBoundingSet = caps;
        AmbientCapabilities = caps;
        ProtectSystem = "full";
        ProtectHome = "yes";
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
        PrivateDevices = true;
        SystemCallFilter = "~@cpu-emulation @debug @keyring @module @mount @obsolete @raw-io";
        MemoryDenyWriteExecute = "yes";
      };
    };
    users = {
      users.bird = {
        description = "BIRD Internet Routing Daemon user";
        group = "bird";
        isSystemUser = true;
      };
      groups.bird = { };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ herbetom ];
  };
}
