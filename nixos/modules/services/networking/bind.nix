{ config, lib, pkgs, ... }:
let

  cfg = config.services.bind;

  bindPkg = config.services.bind.package;

  bindUser = "named";

  bindZoneCoerce = list: builtins.listToAttrs (lib.forEach list (zone: { name = zone.name; value = zone; }));

  bindZoneOptions = { name, config, ... }: {
    options = {
      name = lib.mkOption {
        type = lib.types.str;
        default = name;
        description = "Name of the zone.";
      };
      master = lib.mkOption {
        description = "Master=false means slave server";
        type = lib.types.bool;
      };
      file = lib.mkOption {
        type = lib.types.either lib.types.str lib.types.path;
        description = "Zone file resource records contain columns of data, separated by whitespace, that define the record.";
      };
      masters = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "List of servers for inclusion in stub and secondary zones.";
      };
      slaves = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Addresses who may request zone transfers.";
        default = [ ];
      };
      allowQuery = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = ''
          List of address ranges allowed to query this zone. Instead of the address(es), this may instead
          contain the single string "any".

          NOTE: This overrides the global-level `allow-query` setting, which is set to the contents
          of `cachenetworks`.
        '';
        default = [ "any" ];
      };
      extraConfig = lib.mkOption {
        type = lib.types.str;
        description = "Extra zone config to be appended at the end of the zone section.";
        default = "";
      };
    };
  };

  confFile = pkgs.writeText "named.conf"
    ''
      include "/etc/bind/rndc.key";
      controls {
        inet 127.0.0.1 allow {localhost;} keys {"rndc-key";};
      };

      acl cachenetworks { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
      acl badnetworks { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

      options {
        listen-on { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.listenOn} };
        listen-on-v6 { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.listenOnIpv6} };
        allow-query { cachenetworks; };
        blackhole { badnetworks; };
        forward ${cfg.forward};
        forwarders { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.forwarders} };
        directory "${cfg.directory}";
        pid-file "/run/named/named.pid";
        ${cfg.extraOptions}
      };

      ${cfg.extraConfig}

      ${ lib.concatMapStrings
          ({ name, file, master ? true, slaves ? [], masters ? [], allowQuery ? [], extraConfig ? "" }:
            ''
              zone "${name}" {
                type ${if master then "master" else "slave"};
                file "${file}";
                ${ if master then
                   ''
                     allow-transfer {
                       ${lib.concatMapStrings (ip: "${ip};\n") slaves}
                     };
                   ''
                   else
                   ''
                     masters {
                       ${lib.concatMapStrings (ip: "${ip};\n") masters}
                     };
                   ''
                }
                allow-query { ${lib.concatMapStrings (ip: "${ip}; ") allowQuery}};
                ${extraConfig}
              };
            '')
          (lib.attrValues cfg.zones) }
    '';

in

{

  ###### interface

  options = {

    services.bind = {

      enable = lib.mkEnableOption "BIND domain name server";


      package = lib.mkPackageOption pkgs "bind" { };

      cacheNetworks = lib.mkOption {
        default = [ "127.0.0.0/24" "::1/128" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          What networks are allowed to use us as a resolver.  Note
          that this is for recursive queries -- all networks are
          allowed to query zones configured with the `zones` option
          by default (although this may be overridden within each
          zone's configuration, via the `allowQuery` option).
          It is recommended that you limit cacheNetworks to avoid your
          server being used for DNS amplification attacks.
        '';
      };

      blockedNetworks = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          What networks are just blocked.
        '';
      };

      ipv4Only = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Only use ipv4, even if the host supports ipv6.
        '';
      };

      forwarders = lib.mkOption {
        default = config.networking.nameservers;
        defaultText = lib.literalExpression "config.networking.nameservers";
        type = lib.types.listOf lib.types.str;
        description = ''
          List of servers we should forward requests to.
        '';
      };

      forward = lib.mkOption {
        default = "first";
        type = lib.types.enum ["first" "only"];
        description = ''
          Whether to forward 'first' (try forwarding but lookup directly if forwarding fails) or 'only'.
        '';
      };

      listenOn = lib.mkOption {
        default = [ "any" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Interfaces to listen on.
        '';
      };

      listenOnIpv6 = lib.mkOption {
        default = [ "any" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Ipv6 interfaces to listen on.
        '';
      };

      directory = lib.mkOption {
        type = lib.types.str;
        default = "/run/named";
        description = "Working directory of BIND.";
      };

      zones = lib.mkOption {
        default = [ ];
        type = with lib.types; coercedTo (listOf attrs) bindZoneCoerce (attrsOf (lib.types.submodule bindZoneOptions));
        description = ''
          List of zones we claim authority over.
        '';
        example = {
          "example.com" = {
            master = false;
            file = "/var/dns/example.com";
            masters = [ "192.168.0.1" ];
            slaves = [ ];
            extraConfig = "";
          };
        };
      };

      extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the generated named configuration file.
        '';
      };

      extraOptions = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the options section of the
          generated named configuration file.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = confFile;
        defaultText = lib.literalExpression "confFile";
        description = ''
          Overridable config file to use for named. By default, that
          generated by nixos.
        '';
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    networking.resolvconf.useLocalResolver = lib.mkDefault true;

    users.users.${bindUser} =
      {
        group = bindUser;
        description = "BIND daemon user";
        isSystemUser = true;
      };
    users.groups.${bindUser} = {};

    systemd.services.bind = {
      description = "BIND Domain Name Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        mkdir -m 0755 -p /etc/bind
        if ! [ -f "/etc/bind/rndc.key" ]; then
          ${bindPkg.out}/sbin/rndc-confgen -c /etc/bind/rndc.key -u ${bindUser} -a -A hmac-sha256 2>/dev/null
        fi

        ${pkgs.coreutils}/bin/mkdir -p /run/named
        chown ${bindUser} /run/named

        ${pkgs.coreutils}/bin/mkdir -p ${cfg.directory}
        chown ${bindUser} ${cfg.directory}
      '';

      serviceConfig = {
        Type = "forking"; # Set type to forking, see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=900788
        ExecStart = "${bindPkg.out}/sbin/named -u ${bindUser} ${lib.optionalString cfg.ipv4Only "-4"} -c ${cfg.configFile}";
        ExecReload = "${bindPkg.out}/sbin/rndc -k '/etc/bind/rndc.key' reload";
        ExecStop = "${bindPkg.out}/sbin/rndc -k '/etc/bind/rndc.key' stop";
      };

      unitConfig.Documentation = "man:named(8)";
    };
  };
}
