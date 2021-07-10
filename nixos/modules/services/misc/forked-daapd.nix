{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.forked-daapd;

  configPrimitives = with types; (nullOr (either (either (either bool int) str) path));
  configPrimitivesWithList = with types; (either configPrimitives (listOf configPrimitives));
  configTypes = with types; (either configPrimitivesWithList (attrsOf configPrimitivesWithList));
  toStr = v: if isBool v then boolToString v else toString v;

  boolToYes = b: if b then "yes" else "no";
  listToStrings = l: builtins.concatStringsSep " " (map (x: "\"${toString x}\",") l);

  linesForAttrs = attrs: concatMap (name: let value = attrs.${name}; in
  if isAttrs value
    then [ "${name} {" ] ++ (linesForAttrs value) ++ [ "}" ]
  else if isList value then [ "${name} = { ${(listToStrings value)} }" ]
  else [ "${name}=${toStr value}" ]
  ) (attrNames attrs);

  configFile = pkgs.writeText "forked-daapd.conf" (concatStringsSep "\n" (linesForAttrs cfg.config));

in {
  options.services.forked-daapd = {
    enable = mkEnableOption "";

    libraryPaths = mkOption {
      type = types.listOf types.path;
      description = "List of directories to index";
    };

    user = mkOption {
      type = types.str;
      default = "daapd";
      description = "User account under which forked-daapd runs.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.forked-daapd;
      description = "Package to use.";
    };

    home = mkOption {
      type = types.path;
      default = "/var/lib/forked-daapd";
      description = "The directory where forked-daapd will create files. Make sure it is writable.";
    };

    virtualHost = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Name of the nginx virtualhost to use and setup. If null, do not setup any virtualhost.";
    };

    config = mkOption {
      type = types.attrsOf configTypes;
      default = {};
      example = literalExample ''
        general = {
          loglevel = debug;
        }
      '';
      description = "forked-daapd configuration file. Refer to the sample configuration";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Open ports in the firewall";
    };
  };

  config = mkIf cfg.enable {

    services.forked-daapd.config = mkMerge [
      {
        general = {
          uid = cfg.user;
          logfile = mkDefault "${ cfg.home }/forked-daapd.log";
          db_path = mkDefault "${ cfg.home }/songs3.db";
          cache_path = mkDefault "${ cfg.home }/cache.db";
          websocket_port = mkDefault 3688;
        };
        library = {
          directories = cfg.libraryPaths;
          port = mkDefault 3689;
        };
      }
      (mkIf cfg.openFirewall {
        airplay_shared = {
          control_port = mkDefault 3690;
          timing_port = mkDefault 3691;
        };
      })
    ];

    systemd.services.forked-daapd = {
      description = "DAAP/DACP (iTunes), RSP and MPD server, supports AirPlay and Remote";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/forked-daapd -f -c ${configFile}
        '';
        Restart = "always";
        User = cfg.user;
        UMask = "0022";
      };
    };

    services.avahi = {
      enable = true;
      publish.enable = true;
      publish.userServices = true;
      openFirewall = cfg.openFirewall;
    };

    services.nginx = mkIf (cfg.virtualHost != null) {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts.${cfg.virtualHost} = {
        locations."/".proxyPass = "http://localhost:${toString cfg.config.library.port}";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [
        cfg.config.general.websocket_port
        cfg.config.library.port
      ];
      allowedUDPPorts = [
        cfg.config.airplay_shared.control_port
        cfg.config.airplay_shared.timing_port
      ];
    };

    users.users.daapd = {
      description = "forked-daapd service user";
      name = cfg.user;
      home = cfg.home;
      createHome = true;
      isSystemUser = true;
    };
  };
}
