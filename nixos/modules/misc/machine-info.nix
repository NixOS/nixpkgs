{ config, lib, ... }:
let
  cfg = config.environment.machineInfo;

  needsEscaping = s: builtins.match "[a-zA-Z0-9]+" s == null;
  escapeIfNecessary = s: if needsEscaping s then ''"${lib.escape [ "\$" "\"" "\\" "\`" ] s}"'' else s;
  attrsToText = attrs:
    lib.concatLines (lib.mapAttrsToList
      (name: value: "${name}=${escapeIfNecessary value}")
      (lib.filterAttrs (_: value: value != null) attrs));

  text = attrsToText {
    PRETTY_HOSTNAME = cfg.prettyHostname;
    ICON_NAME = cfg.iconName;
    CHASSIS = cfg.chassis;
    DEPLOYMENT = cfg.deployment;
    LOCATION = cfg.location;
    HARDWARE_VENDOR = cfg.hardwareVendor;
    HARDWARE_MODEL = cfg.hardwareModel;
  };

  mkVarOption = description: lib.mkOption {
    type = lib.types.nullOr lib.types.singleLineStr;
    default = null;
    description = lib.mdDoc description;
  };
in
{
  options.environment.machineInfo = {
    prettyHostname = mkVarOption ''
      A pretty human-readable machine identifier string. If possible, the
      internet hostname as configured in {option}`networking.hostName` should
      be kept similar to this one.
    '';

    iconName = mkVarOption ''
      An icon identifying this machine according to the [XDG Icon Naming
      Specification].

      [XDG Icon Naming Specification]: https://specifications.freedesktop.org/icon-naming-spec/icon-naming-spec-latest.html
    '';

    chassis = mkVarOption ''
      The chassis type. Currently, the following chassis types are defined:
      "desktop", "laptop", "convertible", "server", "tablet", "handset",
      "watch", and "embedded", as well as the special chassis types "vm" and
      "container" for virtualized systems that lack an immediate physical
      chassis.

      Note that most systems allow detection of the chassis type automatically
      (based on firmware information or suchlike). This setting should only be
      used to override a misdetection or to manually configure the chassis
      type where automatic detection is not available.
    '';

    deployment = mkVarOption ''
      System deployment environment. One of the following is suggested:
      "development", "integration", "staging", "production".
    '';

    location = mkVarOption ''
      A free-form human-readable string that describes system location.
    '';

    hardwareVendor = mkVarOption ''
      Specifies the hardware vendor. If unspecified, the hardware vendor set
      in DMI or [hwdb] will be used.

      [hwdb]: https://www.freedesktop.org/software/systemd/man/hwdb.html
    '';

    hardwareModel = mkVarOption ''
      Specifies the hardware model. If unspecified, the hardware model set in
      DMI or [hwdb] will be used.

      [hwdb]: https://www.freedesktop.org/software/systemd/man/hwdb.html
    '';
  };

  config = lib.mkIf (text != "") {
    environment.etc.machine-info = { inherit text; };
  };
}
