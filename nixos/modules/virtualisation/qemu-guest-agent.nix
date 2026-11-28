{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.qemuGuest;

  mkQemuGuestAgentConf = lib.generators.toINI {
    mkKeyValue = lib.generators.mkKeyValueDefault {
      mkValueString =
        value:
        if lib.isBool value then
          if value then "1" else "0"
        else if lib.isList value then
          lib.concatStringsSep "," value
        else if lib.isString value then
          value
        else
          # this case should catched by the module system already
          throw "Unsupported type ${lib.typeOf value} in qemu guest agent config.";
    } "=";
  };

  confFile = pkgs.writeText "qemu-ga.conf" (mkQemuGuestAgentConf cfg.settings);
in
{
  meta.maintainers = [ lib.maintainers.quantenzitrone ];

  options.services.qemuGuest = {
    enable = lib.mkEnableOption "the qemu guest agent";
    package = lib.mkPackageOption pkgs [ "qemu_kvm" "ga" ] { };
    settings = lib.mkOption {
      description = ''
        Settings for the qemu guest agent.
        Refer to the qemu-ga(8) manpage for the list of available settings.
      '';
      type =
        with lib.types;
        attrsOf (
          attrsOf (oneOf [
            bool
            str
            (listOf str)
            # these are all the types of currently available settings
          ])
        );
      default = { };
      example = lib.literalExpression ''
        {
          general = {
            # tight whitelist only allowing graceful shutdowns and usage information
            # from https://lowendtalk.com/discussion/220023/neutralizing-the-security-risk-of-qemu-guest-agent-without-removing-it
            allow-rpcs = [
              "guest-sync-delimited"
              "guest-sync"
              "guest-ping"
              "guest-info"
              "guest-shutdown"
              "guest-get-disks"
              "guest-get-host-name"
              "guest-get-osinfo"
              "guest-get-diskstats"
              "guest-get-cpustats"
              "guest-get-load"
            ];
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.qemuGuest.settings.general.statedir = lib.mkDefault "/run/qemu-ga";

    services.udev.extraRules = ''
      SUBSYSTEM=="virtio-ports", ATTR{name}=="org.qemu.guest_agent.0", TAG+="systemd", ENV{SYSTEMD_WANTS}="qemu-guest-agent.service"
    '';

    systemd.services.qemu-guest-agent = {
      description = "Run the QEMU Guest Agent";
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/qemu-ga --config ${confFile}";
        Restart = "always";
        RestartSec = 0;
        # Runtime directory and mode
        RuntimeDirectory = "qemu-ga";
        RuntimeDirectoryMode = "0755";
      };
    };
  };
}
