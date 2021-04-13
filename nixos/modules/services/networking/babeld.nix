{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.babeld;

  conditionalBoolToString = value: if (isBool value) then (boolToString value) else (toString value);

  paramsString = params:
    concatMapStringsSep " " (name: "${name} ${conditionalBoolToString (getAttr name params)}")
                   (attrNames params);

  interfaceConfig = name:
    let
      interface = getAttr name cfg.interfaces;
    in
    "interface ${name} ${paramsString interface}\n";

  configFile = with cfg; pkgs.writeText "babeld.conf" (
    (optionalString (cfg.interfaceDefaults != null) ''
      default ${paramsString cfg.interfaceDefaults}
    '')
    + (concatMapStrings interfaceConfig (attrNames cfg.interfaces))
    + extraConfig);

in

{

  ###### interface

  options = {

    services.babeld = {

      enable = mkEnableOption "the babeld network routing daemon";

      interfaceDefaults = mkOption {
        default = null;
        description = ''
          A set describing default parameters for babeld interfaces.
          See <citerefentry><refentrytitle>babeld</refentrytitle><manvolnum>8</manvolnum></citerefentry> for options.
        '';
        type = types.nullOr (types.attrsOf types.unspecified);
        example =
          {
            type = "tunnel";
            split-horizon = true;
          };
      };

      interfaces = mkOption {
        default = {};
        description = ''
          A set describing babeld interfaces.
          See <citerefentry><refentrytitle>babeld</refentrytitle><manvolnum>8</manvolnum></citerefentry> for options.
        '';
        type = types.attrsOf (types.attrsOf types.unspecified);
        example =
          { enp0s2 =
            { type = "wired";
              hello-interval = 5;
              split-horizon = "auto";
            };
          };
      };

      extraConfig = mkOption {
        default = "";
        type = types.lines;
        description = ''
          Options that will be copied to babeld.conf.
          See <citerefentry><refentrytitle>babeld</refentrytitle><manvolnum>8</manvolnum></citerefentry> for details.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.babeld.enable {

    systemd.services.babeld = {
      description = "Babel routing daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.babeld}/bin/babeld -c ${configFile} -I /run/babeld/babeld.pid -S /var/lib/babeld/state";
        CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
        IPAddressAllow = [ "fe80::/64" "ff00::/8" "::1/128" "127.0.0.0/8" ];
        IPAddressDeny = "any";
        LockPersonality = true;
        NoNewPrivileges = true;
        MemoryDenyWriteExecute = true;
        ProtectSystem = "strict";
        ProtectClock = true;
        ProtectKernelTunables = false; # Couldn't write sysctl: Read-only file system
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_NETLINK" "AF_INET6" "AF_INET" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        ProtectHome = true;
        ProtectHostname = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = false; # kernel_route(ADD): Operation not permitted
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
        UMask = "0177";
        RuntimeDirectory = "babeld";
        StateDirectory = "babeld";
      };
    };
  };
}
