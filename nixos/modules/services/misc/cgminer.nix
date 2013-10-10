{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.services.cgminer;

  convType = with builtins;
    v: if isBool v then (if v then "true" else "false") else toString v;
  mergedHwConfig =
    mapAttrsToList (n: v: ''"${n}": "${(concatStringsSep "," (map convType v))}"'')
      (foldAttrs (n: a: [n] ++ a) [] cfg.hardware);
  mergedConfig = with builtins;
    mapAttrsToList (n: v: ''"${n}":  ${if isBool v then "" else ''"''}${convType v}${if isBool v then "" else ''"''}'')
      cfg.config;

  cgminerConfig = pkgs.writeText "cgminer.conf" ''
  {
  ${concatStringsSep ",\n" mergedHwConfig},
  ${concatStringsSep ",\n" mergedConfig},
  "pools": [
  ${concatStringsSep ",\n"
    (map (v: ''{"url": "${v.url}", "user": "${v.user}", "pass": "${v.pass}"}'')
          cfg.pools)}]
  }
  '';
in
{
  ###### interface
  options = {

    services.cgminer = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable cgminer, an ASIC/FPGA/GPU miner for bitcoin and
          litecoin.
        '';
      };

      package = mkOption {
        default = pkgs.cgminer;
        description = "Which cgminer derivation to use.";
      };

      user = mkOption {
        default = "cgminer";
        description = "User account under which cgminer runs";
      };

      pools = mkOption {
        default = [];  # Run benchmark
        description = "List of pools where to mine";
        example = [{
          url = "http://p2pool.org:9332";
          username = "17EUZxTvs9uRmPsjPZSYUU3zCz9iwstudk";
          password="X";
        }];
      };

      hardware = mkOption {
        default = []; # Run without options
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

      config = mkOption {
        default = {};
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

  config = mkIf config.services.cgminer.enable {

    users.extraUsers = singleton
      { name = cfg.user;
        description = "Cgminer user";
      };

    environment.systemPackages = [ cfg.package ];

    systemd.services.cgminer = {
      path = [ pkgs.cgminer ];

      after = [ "display-manager.target" "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = { 
        LD_LIBRARY_PATH = ''/run/opengl-driver/lib:/run/opengl-driver-32/lib'';
        DISPLAY = ":0";
        GPU_MAX_ALLOC_PERCENT = "100";
        GPU_USE_SYNC_OBJECTS = "1";
      };

      serviceConfig = {
        ExecStart = "${pkgs.cgminer}/bin/cgminer -T -c ${cgminerConfig}";
        User = cfg.user;
        RestartSec = 10;
      };
    };

  };

}
