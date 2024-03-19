{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.corectrl;
in
{
  options.programs.corectrl = {
    enable = mkEnableOption (lib.mdDoc ''
      CoreCtrl, a tool to overclock amd graphics cards and processors.
      Add your user to the corectrl group to run corectrl without needing to enter your password
    '');

    package = mkPackageOption pkgs "corectrl" {
      extraDescription = "Useful for overriding the configuration options used for the package.";
    };

    gpuOverclock = {
      enable = mkEnableOption (lib.mdDoc ''
        GPU overclocking
      '');
      ppfeaturemask = mkOption {
        type = types.str;
        default = "0xfffd7fff";
        example = "0xffffffff";
        description = lib.mdDoc ''
          Sets the `amdgpu.ppfeaturemask` kernel option.
          In particular, it is used here to set the overdrive bit.
          Default is `0xfffd7fff` as it is less likely to cause flicker issues.
          Setting it to `0xffffffff` enables all features.
        '';
      };
    };
  };

  config = mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.package ];

      services.dbus.packages = [ cfg.package ];

      users.groups.corectrl = { };

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if ((action.id == "org.corectrl.helper.init" ||
                 action.id == "org.corectrl.helperkiller.init") &&
                subject.local == true &&
                subject.active == true &&
                subject.isInGroup("corectrl")) {
                    return polkit.Result.YES;
            }
        });
      '';
    }

    (lib.mkIf cfg.gpuOverclock.enable {
      # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/gpu/drm/amd/include/amd_shared.h#n169
      # The overdrive bit
      boot.kernelParams = [ "amdgpu.ppfeaturemask=${cfg.gpuOverclock.ppfeaturemask}" ];
    })
  ]);

  meta.maintainers = with lib.maintainers; [ artturin ];
}
