{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ethminer;
  poolUrl = escapeShellArg "stratum1+tcp://${cfg.wallet}@${cfg.pool}:${toString cfg.stratumPort}/${cfg.rig}/${cfg.registerMail}";
in

{

  ###### interface

  options = {

    services.ethminer = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable ethminer ether mining.";
      };

      recheckInterval = mkOption {
        type = types.int;
        default = 2000;
        description = "Interval in milliseconds between farm rechecks.";
      };

      toolkit = mkOption {
        type = types.enum [ "cuda" "opencl" ];
        default = "cuda";
        description = "Cuda or opencl toolkit.";
      };

      apiPort = mkOption {
        type = types.int;
        default = -3333;
        description = "Ethminer api port. minus sign puts api in read-only mode.";
      };

      wallet = mkOption {
        type = types.str;
        example = "0x0123456789abcdef0123456789abcdef01234567";
        description = "Ethereum wallet address.";
      };

      pool = mkOption {
        type = types.str;
        example = "eth-us-east1.nanopool.org";
        description = "Mining pool address.";
      };

      stratumPort = mkOption {
        type = types.port;
        default = 9999;
        description = "Stratum protocol tcp port.";
      };

      rig = mkOption {
        type = types.str;
        default = "mining-rig-name";
        description = "Mining rig name.";
      };

      registerMail = mkOption {
        type = types.str;
        example = "email%40example.org";
        description = "Url encoded email address to register with pool.";
      };

      maxPower = mkOption {
        type = types.int;
        default = 115;
        description = "Miner max watt usage.";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.ethminer = {
      path = [ pkgs.cudatoolkit ];
      description = "ethminer ethereum mining service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStartPost = optional (cfg.toolkit == "cuda") "+${getBin config.boot.kernelPackages.nvidia_x11}/bin/nvidia-smi -pl ${toString cfg.maxPower}";
      };

      environment = {
        LD_LIBRARY_PATH = "${config.boot.kernelPackages.nvidia_x11}/lib";
      };

      script = ''
        ${pkgs.ethminer}/bin/.ethminer-wrapped \
          --farm-recheck ${toString cfg.recheckInterval} \
          --report-hashrate \
          --${cfg.toolkit} \
          --api-port ${toString cfg.apiPort} \
          --pool ${poolUrl}
      '';

    };

  };

}
