{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.cpu.intel.pegCpu;

  machineConfigs = {
    dell_latitude_e6x00 = {
      link = "https://wiki.archlinux.org/index.php/Dell_Latitude_E6x00";
      read = "44:32 0xCE";
      write = [
        "0x199 0x$val"
        "0x19A 0x0"
      ];
    };
  };

  machine = builtins.getAttr cfg.machine machineConfigs;

  script = pkgs.writeScript "peg-cpu.sh" (with pkgs; ''
    #!${runtimeShell} -e

    # ${machine.link}

    val=$(${msr-tools}/bin/rdmsr -f ${machine.read})

    while : ; do
      ${concatStringsSep "\n" (map (r: "${msr-tools}/bin/wrmsr --all ${r}") machine.write)}
      ${coreutils}/bin/sleep ${cfg.sleepInterval}
    done
  '');

in {

  ###### interface

  options = {

    hardware.cpu.intel.pegCpu = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Peg the CPU to run at max speed to work around broken throttling. Unless you know that you need this, you probably don't.
          </para>
          <para>
          WARNING: This is likely to harm you computer as it WILL cause it to run significantly hotter!!!
        '';
      };

      machine = mkOption {
        default = null;
        type = types.nullOr (types.enum (attrNames machineConfigs));
        description = ''
          The machine type for which you want to disable throttling by pegging the CPU at the maximum power state.
        '';
      };

      sleepInterval = mkOption {
        default = "0.1";
        type = types.string;
        description = ''How long to sleep after reading/writing the registers.'';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.pegCpu.enable && cfg.machine != null {

    boot.kernelModules = [ "cpuid" ];

    systemd.services.peg-cpu = {
      description = "Peg CPU at full speed";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = script;
        Restart = "on-failure";
        PrivateNetwork = true;
        PrivateTmp = true;
      };
    };
  };
}
