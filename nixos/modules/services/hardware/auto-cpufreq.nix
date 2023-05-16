{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.auto-cpufreq;
  cfgFilename = "auto-cpufreq.conf";
  cfgFile = format.generate cfgFilename cfg.settings;

  format = pkgs.formats.ini {};
in {
  options = {
    services.auto-cpufreq = {
      enable = mkEnableOption (lib.mdDoc "auto-cpufreq daemon");

      settings = mkOption {
        description = lib.mdDoc ''
          Configuration for `auto-cpufreq`.

<<<<<<< HEAD
          The available options can be found in [the example configuration file](https://github.com/AdnanHodzic/auto-cpufreq/blob/v${pkgs.auto-cpufreq.version}/auto-cpufreq.conf-example).
=======
          See its [example configuration file] for supported settings.
          [example configuration file]: https://github.com/AdnanHodzic/auto-cpufreq/blob/master/auto-cpufreq.conf-example
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          '';

        default = {};
        type = types.submodule { freeformType = format.type; };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.auto-cpufreq ];

    systemd = {
      packages = [ pkgs.auto-cpufreq ];
      services.auto-cpufreq = {
        # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
        wantedBy = [ "multi-user.target" ];
        path = with pkgs; [ bash coreutils ];

<<<<<<< HEAD
        serviceConfig.WorkingDirectory = "";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        serviceConfig.ExecStart = [
          ""
          "${lib.getExe pkgs.auto-cpufreq} --daemon --config ${cfgFile}"
        ];
      };
    };
  };
<<<<<<< HEAD

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
