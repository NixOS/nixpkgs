{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.bind;

  bindPkg = config.services.bind.package;

  bindUser = "named";

  bindZoneCoerce = list: builtins.listToAttrs (lib.forEach list (zone: { name = zone.name; value = zone; }));

  bindZoneOptions = { name, config, ... }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "Name of the zone.";
      };
      master = mkOption {
        description = "Master=false means slave server";
        type = types.bool;
      };
      file = mkOption {
        type = types.either types.str types.path;
        description = "Zone file resource records contain columns of data, separated by whitespace, that define the record.";
      };
      masters = mkOption {
        type = types.listOf types.str;
        description = "List of servers for inclusion in stub and secondary zones.";
      };
      slaves = mkOption {
        type = types.listOf types.str;
        description = "Addresses who may request zone transfers.";
        default = [ ];
      };
      extraConfig = mkOption {
        type = types.str;
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

      acl cachenetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
      acl badnetworks { ${concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

      options {
        listen-on { ${concatMapStrings (entry: " ${entry}; ") cfg.listenOn} };
        listen-on-v6 { ${concatMapStrings (entry: " ${entry}; ") cfg.listenOnIpv6} };
        allow-query { cachenetworks; };
        blackhole { badnetworks; };
        forward ${cfg.forward};
        forwarders { ${concatMapStrings (entry: " ${entry}; ") cfg.forwarders} };
        directory "${cfg.directory}";
        pid-file "/run/named/named.pid";
        ${cfg.extraOptions}
      };

      ${cfg.extraConfig}

      ${ concatMapStrings
          ({ name, file, master ? true, slaves ? [], masters ? [], extraConfig ? "" }:
            ''
              zone "${name}" {
                type ${if master then "master" else "slave"};
                file "${file}";
                ${ if master then
                   ''
                     allow-transfer {
                       ${concatMapStrings (ip: "${ip};\n") slaves}
                     };
                   ''
                   else
                   ''
                     masters {
                       ${concatMapStrings (ip: "${ip};\n") masters}
                     };
                   ''
                }
                allow-query { any; };
                ${extraConfig}
              };
            '')
          (attrValues cfg.zones) }
    '';

in

{

  ###### interface

  options = {

    services.bind = {

      enable = mkEnableOption "BIND domain name server";


      package = mkOption {
        type = types.package;
        default = pkgs.bind;
        defaultText = literalExpression "pkgs.bind";
        description = "The BIND package to use.";
      };

      cacheNetworks = mkOption {
        default = [ "127.0.0.0/24" ];
        type = types.listOf types.str;
        description = "
          What networks are allowed to use us as a resolver.  Note
          that this is for recursive queries -- all networks are
          allowed to query zones configured with the `zones` option.
          It is recommended that you limit cacheNetworks to avoid your
          server being used for DNS amplification attacks.
        ";
      };

      blockedNetworks = mkOption {
        default = [ ];
        type = types.listOf types.str;
        description = "
          What networks are just blocked.
        ";
      };

      ipv4Only = mkOption {
        default = false;
        type = types.bool;
        description = "
          Only use ipv4, even if the host supports ipv6.
        ";
      };

      forwarders = mkOption {
        default = config.networking.nameservers;
        defaultText = literalExpression "config.networking.nameservers";
        type = types.listOf types.str;
        description = "
          List of servers we should forward requests to.
        ";
      };

      forward = mkOption {
        default = "first";
        type = types.enum ["first" "only"];
        description = "
          Whether to forward 'first' (try forwarding but lookup directly if forwarding fails) or 'only'.
        ";
      };

      listenOn = mkOption {
        default = [ "any" ];
        type = types.listOf types.str;
        description = "
          Interfaces to listen on.
        ";
      };

      listenOnIpv6 = mkOption {
        default = [ "any" ];
        type = types.listOf types.str;
        description = "
          Ipv6 interfaces to listen on.
        ";
      };

      directory = mkOption {
        type = types.str;
        default = "/run/named";
        description = "Working directory of BIND.";
      };

      zones = mkOption {
        default = [ ];
        type = with types; coercedTo (listOf attrs) bindZoneCoerce (attrsOf (types.submodule bindZoneOptions));
        description = "
          List of zones we claim authority over.
        ";
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "
          Extra lines to be added verbatim to the generated named configuration file.
        ";
      };

      extraOptions = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra lines to be added verbatim to the options section of the
          generated named configuration file.
        '';
      };

      configFile = mkOption {
        type = types.path;
        default = confFile;
        defaultText = literalExpression "confFile";
        description = "
          Overridable config file to use for named. By default, that
          generated by nixos.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    networking.resolvconf.useLocalResolver = mkDefault true;

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
        ExecStart = "${bindPkg.out}/sbin/named -u ${bindUser} ${optionalString cfg.ipv4Only "-4"} -c ${cfg.configFile} -f";
        ExecReload = "${bindPkg.out}/sbin/rndc -k '/etc/bind/rndc.key' reload";
        ExecStop = "${bindPkg.out}/sbin/rndc -k '/etc/bind/rndc.key' stop";
      };

      unitConfig.Documentation = "man:named(8)";
    };
  };
}
