{ config, lib, pkgs, ... }:
let
  cfg = config.services.cgminer;

  convType = with builtins;
    v: if lib.isBool v then lib.boolToString v else toString v;
  mergedHwConfig =
    lib.mapAttrsToList (n: v: ''"${n}": "${(lib.concatStringsSep "," (map convType v))}"'')
      (lib.foldAttrs (n: a: [n] ++ a) [] cfg.hardware);
  mergedConfig = with builtins;
    lib.mapAttrsToList (n: v: ''"${n}":  ${if lib.isBool v then convType v else ''"${convType v}"''}'')
      cfg.config;

  cgminerConfig = pkgs.writeText "cgminer.conf" ''
  {
  ${lib.concatStringsSep ",\n" mergedHwConfig},
  ${lib.concatStringsSep ",\n" mergedConfig},
  "pools": [
  ${lib.concatStringsSep ",\n"
    (map (v: ''{"url": "${v.url}", "user": "${v.user}", "pass": "${v.pass}"}'')
          cfg.pools)}]
  }
  '';
in
{
  ###### interface
  options = {

    services.cgminer = {

      enable = lib.mkEnableOption "cgminer, an ASIC/FPGA/GPU miner for bitcoin and litecoin";

      package = lib.mkPackageOption pkgs "cgminer" { };

      user = lib.mkOption {
        type = lib.types.str;
        default = "cgminer";
        description = "User account under which cgminer runs";
      };

      pools = lib.mkOption {
        default = [];  # Run benchmark
        type = lib.types.listOf (lib.types.attrsOf lib.types.str);
        description = "List of pools where to mine";
        example = [{
          url = "http://p2pool.org:9332";
          username = "17EUZxTvs9uRmPsjPZSYUU3zCz9iwstudk";
          password="X";
        }];
      };

      hardware = lib.mkOption {
        default = []; # Run without options
        type = lib.types.listOf (lib.types.attrsOf (lib.types.either lib.types.str lib.types.int));
        description= "List of config options for every GPU";
        example = [
        {
          intensity = 9;
          gpu-engine = "0-985";
          gpu-fan = "0-85";
          gpu-memclock = 860;
          gpu-powertune = 20;
          temp-cutoff = 95;
          temp-overheat = 85;
          temp-target = 75;
        }
        {
          intensity = 9;
          gpu-engine = "0-950";
          gpu-fan = "0-85";
          gpu-memclock = 825;
          gpu-powertune = 20;
          temp-cutoff = 95;
          temp-overheat = 85;
          temp-target = 75;
        }];
      };

      config = lib.mkOption {
        default = {};
        type = lib.types.attrsOf (lib.types.either lib.types.bool lib.types.int);
        description = "Additional config";
        example = {
          auto-fan = true;
          auto-gpu = true;
          expiry = 120;
          failover-only = true;
          gpu-threads = 2;
          log = 5;
          queue = 1;
          scan-time = 60;
          temp-histeresys = 3;
        };
      };
    };
  };


  ###### implementation

  config = lib.mkIf config.services.cgminer.enable {

    users.users = lib.optionalAttrs (cfg.user == "cgminer") {
      cgminer = {
        isSystemUser = true;
        group = "cgminer";
        description = "Cgminer user";
      };
    };
    users.groups = lib.optionalAttrs (cfg.user == "cgminer") {
      cgminer = {};
    };

    environment.systemPackages = [ cfg.package ];

    systemd.services.cgminer = {
      path = [ pkgs.cgminer ];

      after = [ "network.target" "display-manager.service" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        LD_LIBRARY_PATH = "/run/opengl-driver/lib:/run/opengl-driver-32/lib";
        DISPLAY = ":${toString config.services.xserver.display}";
        GPU_MAX_ALLOC_PERCENT = "100";
        GPU_USE_SYNC_OBJECTS = "1";
      };

      startLimitIntervalSec = 60;  # 1 min
      serviceConfig = {
        ExecStart = "${pkgs.cgminer}/bin/cgminer --syslog --text-only --config ${cgminerConfig}";
        User = cfg.user;
        RestartSec = "30s";
        Restart = "always";
      };
    };

  };

}
