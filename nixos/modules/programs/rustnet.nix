{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.rustnet;

in
{
  options = {
    programs.rustnet = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to add rustnet to the global environment and configure a
          setcap wrapper for it. The wrapper grants the capabilities
          required for read-only packet capture (`cap_net_raw`) and for
          eBPF-enhanced process tracking (`cap_bpf`, `cap_perfmon`),
          allowing any user to run rustnet without sudo.
        '';
      };

      package = lib.mkPackageOption pkgs "rustnet" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security.wrappers.rustnet = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw,cap_bpf,cap_perfmon+eip";
      source = lib.getExe cfg.package;
    };
  };

  meta.maintainers = with lib.maintainers; [ dvaerum ];
}
