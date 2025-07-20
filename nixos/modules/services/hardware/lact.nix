{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.lact;
in
{
  meta.maintainers = [ lib.maintainers.johnrtitor ];

  options.services.lact = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable LACT, a tool for monitoring, configuring and overclocking GPUs.

        ::: {.note}
        If you are on an AMD GPU, it is recommended to enable overdrive mode by using
        `hardware.amdgpu.overdrive.enable = true;` in your configuration.
        See [LACT wiki](https://github.com/ilya-zlobintsev/LACT/wiki/Overclocking-(AMD)) for more information.
        :::
      '';
    };

    package = lib.mkPackageOption pkgs "lact" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.services.lactd = {
      description = "LACT GPU Control Daemon";
      wantedBy = [ "multi-user.target" ];
    };
  };
}
