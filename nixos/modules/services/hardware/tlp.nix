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
        if isList val then "\"" + (toString val) + "\""
        else toString val;
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
        description = lib.mdDoc "Whether to enable the TLP power management daemon.";
      };

      settings = mkOption {type = with types; attrsOf (oneOf [bool int float str (listOf str)]);
        default = {};
        example = {
          SATA_LINKPWR_ON_BAT = "med_power_with_dipm";
          USB_BLACKLIST_PHONE = 1;
        };
        description = lib.mdDoc ''
          Options passed to TLP. See https://linrunner.de/tlp for all supported options..
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Verbatim additional configuration variables for TLP.
          DEPRECATED: use services.tlp.settings instead.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    boot.kernelModules = [ "msr" ];

    warnings = optional (cfg.extraConfig != "") ''
      Using config.services.tlp.extraConfig is deprecated and will become unsupported in a future release. Use config.services.tlp.settings instead.
    '';

    assertions = [{
      assertion = cfg.enable -> config.powerManagement.scsiLinkPolicy == null;
      message = ''
        `services.tlp.enable` and `config.powerManagement.scsiLinkPolicy` cannot be set both.
        Set `services.tlp.settings.SATA_LINKPWR_ON_AC` and `services.tlp.settings.SATA_LINKPWR_ON_BAT` instead.
      '';
    }];

    environment.etc = {
      "tlp.conf".text = (mkTlpConfig cfg.settings) + cfg.extraConfig;
    } // optionalAttrs enableRDW {
      "NetworkManager/dispatcher.d/99tlp-rdw-nm".source =
        "${tlp}/etc/NetworkManager/dispatcher.d/99tlp-rdw-nm";
    };

    environment.systemPackages = [ tlp ];


    services.tlp.settings = let
      cfg = config.powerManagement;
      maybeDefault = val: lib.mkIf (val != null) (lib.mkDefault val);
    in {
      CPU_SCALING_GOVERNOR_ON_AC = maybeDefault cfg.cpuFreqGovernor;
      CPU_SCALING_GOVERNOR_ON_BAT = maybeDefault cfg.cpuFreqGovernor;
      CPU_SCALING_MIN_FREQ_ON_AC = maybeDefault cfg.cpufreq.min;
      CPU_SCALING_MAX_FREQ_ON_AC = maybeDefault cfg.cpufreq.max;
      CPU_SCALING_MIN_FREQ_ON_BAT = maybeDefault cfg.cpufreq.min;
      CPU_SCALING_MAX_FREQ_ON_BAT = maybeDefault cfg.cpufreq.max;
    };

    services.udev.packages = [ tlp ];

    systemd = {
      # use native tlp instead because it can also differentiate between AC/BAT
      services.cpufreq.enable = false;

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
