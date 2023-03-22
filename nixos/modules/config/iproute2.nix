{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.iproute2;

  mkEntry = path: settings: {
    name = path;
    value = {
      mode = "0644";
      text = fileContents "${pkgs.iproute2}/etc/${path}"
        + lib.optionalString (settings != { }) "\n\n\n"
        + lib.concatStringsSep "\n"
        (lib.mapAttrsToList (n: v: "${toString v}	${n}") settings);
    };
  };

  mkSettingsOption = file:
    mkOption {
      type = types.attrsOf types.ints.u32;
      default = { };
      example = {
        name = 42;
      };
      description = lib.mdDoc ''
        Mappings to be added to /etc/iproute2/${file}.
      '';
    };

in {
  imports = [
    (lib.mkRemovedOptionModule [
      "networking"
      "iproute2"
      "rttablesExtraConfig"
    ] ''
      This option was removed in favour of `networking.iproute.settings.rttables`.
    '')
  ];

  options.networking.iproute2 = {
    enable = mkEnableOption (lib.mdDoc "copy IP route configuration files");
    settings = {
      bpf_pinning = mkSettingsOption "bpf_pinning";
      ematch_map = mkSettingsOption "ematch_map";
      group = mkSettingsOption "group";
      nl_protos = mkSettingsOption "nl_protos";
      rt_dsfield = mkSettingsOption "rt_dsfield";
      rt_protos = mkSettingsOption "rt_protos";
      rt_realms = mkSettingsOption "rt_realms";
      rt_scopes = mkSettingsOption "rt_scopes";
      rt_tables = mkSettingsOption "rt_tables";
    };
  };

  config = mkIf cfg.enable {
    environment.etc = builtins.listToAttrs [
      (mkEntry "iproute2/bpf_pinning" cfg.settings.bpf_pinning)
      (mkEntry "iproute2/ematch_map" cfg.settings.ematch_map)
      (mkEntry "iproute2/group" cfg.settings.group)
      (mkEntry "iproute2/nl_protos" cfg.settings.nl_protos)
      (mkEntry "iproute2/rt_dsfield" cfg.settings.rt_dsfield)
      (mkEntry "iproute2/rt_protos" cfg.settings.rt_protos)
      (mkEntry "iproute2/rt_realms" cfg.settings.rt_realms)
      (mkEntry "iproute2/rt_scopes" cfg.settings.rt_scopes)
      (mkEntry "iproute2/rt_tables" cfg.settings.rt_tables)
    ];
  };
}
