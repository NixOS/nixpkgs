{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.programs.pqos-wrapper;
in
{
  options.programs.pqos-wrapper = {
    enable = lib.mkEnableOption "PQoS Wrapper for BenchExec";
    package = lib.mkPackageOption pkgs "pqos-wrapper" { };
  };

  config = lib.mkIf cfg.enable {
    hardware.cpu.x86.msr.enable = true;

    security.wrappers.${cfg.package.meta.mainProgram} = {
      owner = "nobody";
      group = config.hardware.cpu.x86.msr.group;
      source = lib.getExe cfg.package;
      capabilities = "cap_sys_rawio=eip";
    };
  };

  meta.maintainers = with lib.maintainers; [ lorenzleutgeb ];
}
