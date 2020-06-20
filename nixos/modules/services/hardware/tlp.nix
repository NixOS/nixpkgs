{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.tlp;
  enableRDW = config.networking.networkmanager.enable;
  tlp = pkgs.tlp.override { inherit enableRDW; };
  # TODO: Use this for having proper parameters in the future
  mkTlpConfig = tlpConfig: generators.toKeyValue {
    mkKeyValue = generators.mkKeyValueDefault {
      mkValueString = val:
        if isInt val then toString val
        else if isString val then val
        else if true == val then "1"
        else if false == val then "0"
        else if isList val then "\"" + (concatStringsSep " " val) + "\""
        else err "invalid value provided to mkTlpConfig:" (toString val);
    } "=";
  } tlpConfig;
in
{
  ###### interface
  options = {
    services.tlp = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the TLP power management daemon.";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional configuration variables for TLP";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    boot.kernelModules = [ "msr" ];

    environment.etc = {
      "tlp.conf".text = cfg.extraConfig;
    } // optionalAttrs enableRDW {
      "NetworkManager/dispatcher.d/99tlp-rdw-nm".source =
        "${tlp}/etc/NetworkManager/dispatcher.d/99tlp-rdw-nm";
    };

    environment.systemPackages = [ tlp ];

    # FIXME: When the config is parametrized we need to move these into a
    # conditional on the relevant options being enabled.
    powerManagement = {
      scsiLinkPolicy = null;
      cpuFreqGovernor = null;
      cpufreq.max = null;
      cpufreq.min = null;
    };

    services.udev.packages = [ tlp ];

    systemd = {
      packages = [ tlp ];
      # XXX: These must always be disabled/masked according to [1].
      #
      # [1]: https://github.com/linrunner/TLP/blob/a9ada09e0821f275ce5f93dc80a4d81a7ff62ae4/tlp-stat.in#L319
      sockets.systemd-rfkill.enable = false;
      services.systemd-rfkill.enable = false;

      services.tlp = {
        # XXX: The service should reload whenever the configuration changes,
        # otherwise newly set power options remain inactive until reboot (or
        # manual unit restart.)
        restartTriggers = [ config.environment.etc."tlp.conf".source ];
        # XXX: When using systemd.packages (which we do above) the [Install]
        # section of systemd units does not work (citation needed) so we manually
        # enforce it here.
        wantedBy = [ "multi-user.target" ];
      };

      services.tlp-sleep = {
        # XXX: When using systemd.packages (which we do above) the [Install]
        # section of systemd units does not work (citation needed) so we manually
        # enforce it here.
        before = [ "sleep.target" ];
        wantedBy = [ "sleep.target" ];
        # XXX: `tlp suspend` requires /var/lib/tlp to exist in order to save
        # some stuff in there. There is no way, that I know of, to do this in
        # the package itself, so we do it here instead making sure the unit
        # won't fail due to the save dir not existing.
        serviceConfig.StateDirectory = "tlp";
      };
    };
  };
}
