{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.hetzner-api-dyndns;
  ifNotNull = opt: val: lib.optionalString (val != null) "-${opt} ${escapeShellArg val}";
  baseCmd = "hetzner-dyndns ${ifNotNull "Z" cfg.zoneName} ${ifNotNull "z" cfg.zoneId} -n ${escapeShellArg cfg.recordName}  -t ${toString cfg.ttl}";
in {
  meta.maintainers = with lib.maintainers; [ e1mo ];

  options.services.hetzner-api-dyndns = {
    enable = mkEnableOption (lib.mdDoc "dynamic DNS record updating via the Hetzner DNS API.");
    recordName = mkOption {
      type = types.str;
      example = "dyn";
      description = lib.mdDoc ''
        The name of the record to update.
        Use `@` to update the root record for the zone itself.
      '';
    };
    recordTypes = mkOption {
      type = types.nonEmptyListOf (types.enum [ "AAAA" "A" ]);
      default = [ "AAAA" "A" ];
      example = [ "A" ];
      description = lib.mdDoc "The record type(s) to update automatically (A for IPv4, AAAA for IPv6).";
    };
    zoneName = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "my-zone.net";
      description = lib.mdDoc ''
        The zone name for which to update the selected record(s).
        Mutually exclusive with {option}`services.hetzner-api-dyndns.zoneId`.
      '';
    };
    zoneId = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "DaGaoE6YzDTQHKxrtzfkTx";
      description = lib.mdDoc ''
        The zone ID (Hetzner specific).
        Mutually exclusive with {option}`services.hetzner-api-dyndns.zoneName`.
      '';
    };
    environmentFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Environment file containing the {env}`HETZNER_AUTH_API_TOKEN` variable.
        See <https://github.com/FarrowStrange/hetzner-api-dyndns> for other available options.
      '';
    };
    ttl = mkOption {
      type = types.ints.positive;
      default = 60;
      example = 120;
      description = lib.mdDoc "TTL of the record(s), in seconds.";
    };
    startAt =  mkOption {
      type = types.str;
      default = "*:0/5";
      example = "hourly";
      description = lib.mdDoc ''
        When (aka. how often) to run the script. Default is every five minutes.
        Must be in the format described in {manpage}`systemd.time(7)`.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [{
      assertion = with cfg; (zoneName != zoneId) && (zoneName == null || zoneId == null);
      message = "Exactly one of `services.hetzner-api-dyndns.zoneName' and `services.hetzner-api-dyndns.zoneId' must be set.";
    }];

    systemd.services."hetzner-api-dyndns" = {
      inherit (cfg) startAt;
      path = [ pkgs.hetzner-api-dyndns ];
      script = concatMapStringsSep "\n" (
        rt: "${baseCmd} -T ${rt}"
      ) cfg.recordTypes;
      requires = [ "network-online.target" ];
      serviceConfig = {
        EnvironmentFile = cfg.environmentFile;
        DynamicUser = true;
      };
    };
  };
}
