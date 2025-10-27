{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.bind;

  bindPkg = config.services.bind.package;

  bindUser = "named";

  bindZoneCoerce =
    list:
    builtins.listToAttrs (
      lib.forEach list (zone: {
        name = zone.name;
        value = zone;
      })
    );

  bindRndcMacType = "hmac-sha256";

  bindRndcKeyFile = "/etc/bind/rndc.key";

  bindNamedExe = lib.getExe' bindPkg "named";

  bindRndcExe = lib.getExe' bindPkg "rndc";

  bindZoneOptions =
    { name, config, ... }:
    {
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
          '';
          default = [ "any" ];
        };
        extraConfig = lib.mkOption {
          type = lib.types.lines;
          description = "Extra zone config to be appended at the end of the zone section.";
          default = "";
        };
      };
    };

  testRndcKey = pkgs.writeTextFile {
    name = "testrndc.key";
    text = ''
      key "rndc-key" {
        algorithm ${bindRndcMacType};
        secret "0123456789abcdefghijklmnopqrstuvw=";
      };
    '';
  };

  confFile = pkgs.writeTextFile {
    name = "named.conf";
    checkPhase = ''
      runHook preCheck
      echo "Checking named configuration file...";
      ${lib.getExe' bindPkg "named-checkconf"} -z $target -t ${cfg.directory}
      runHook postCheck
    '';
    derivationArgs = {
      doCheck = true;
      postCheck = ''
        substituteInPlace $target --replace-fail ${testRndcKey} ${bindRndcKeyFile}
      '';
    };

    # The include path in the first line will be replaced in the postCheck hook.
    text = ''
      include "${testRndcKey}";
      controls {
        inet 127.0.0.1 allow {localhost;} keys {"rndc-key";};
      };

      acl cachenetworks { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.cacheNetworks} };
      acl badnetworks { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.blockedNetworks} };

      options {
        listen-on { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.listenOn} };
        listen-on-v6 { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.listenOnIpv6} };
        allow-query-cache { cachenetworks; };
        blackhole { badnetworks; };
        forward ${cfg.forward};
        forwarders { ${lib.concatMapStrings (entry: " ${entry}; ") cfg.forwarders} };
        directory "${cfg.directory}";
        pid-file "/run/named/named.pid";
        ${cfg.extraOptions}
      };

      ${cfg.extraConfig}

      ${lib.concatMapStrings (
        {
          name,
          file,
          master ? true,
          slaves ? [ ],
          masters ? [ ],
          allowQuery ? [ ],
          extraConfig ? "",
        }:
        ''
          zone "${name}" {
            type ${if master then "master" else "slave"};
            file "${file}";
            ${
              if master then
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
        ''
      ) (lib.attrValues cfg.zones)}
    '';
  };
in

{

  ###### interface

  options = {

    services.bind = {

      enable = lib.mkEnableOption "BIND domain name server";

      package = lib.mkPackageOption pkgs "bind" { };

      cacheNetworks = lib.mkOption {
        default = [
          "127.0.0.0/24"
          "::1/128"
        ];
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
        type = lib.types.enum [
          "first"
          "only"
        ];
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

      listenOnPort = lib.mkOption {
        default = 53;
        type = lib.types.port;
        description = ''
          Port to listen on.
        '';
      };

      listenOnIpv6 = lib.mkOption {
        default = [ "any" ];
        type = lib.types.listOf lib.types.str;
        description = ''
          Ipv6 interfaces to listen on.
        '';
      };

      listenOnIpv6Port = lib.mkOption {
        default = 53;
        type = lib.types.port;
        description = ''
          Ipv6 port to listen on.
        '';
      };

      directory = lib.mkOption {
        type = lib.types.str;
        default = "/run/named";
        description = "Working directory of BIND.";
      };

      zones = lib.mkOption {
        default = [ ];
        type =
          with lib.types;
          coercedTo (listOf attrs) bindZoneCoerce (attrsOf (lib.types.submodule bindZoneOptions));
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

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Additional command-line arguments to pass to named.
        '';
        example = [
          "-n"
          "4"
        ];
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = confFile;
        defaultText = lib.literalExpression "confFile";
        description = ''
          Overridable config file to use for named. By default, that
          generated by nixos. If overriden, it will not be checked by
          named-checkconf.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    networking.resolvconf.useLocalResolver = lib.mkDefault true;

    users.users.${bindUser} = {
      group = bindUser;
      description = "BIND daemon user";
      isSystemUser = true;
    };
    users.groups.${bindUser} = { };

    systemd.tmpfiles.settings."bind" = lib.mkIf (cfg.directory != "/run/named") {
      ${cfg.directory} = {
        d = {
          user = bindUser;
          group = bindUser;
          age = "-";
        };
      };
    };
    systemd.services.bind = {
      description = "BIND Domain Name Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if ! [ -f ${bindRndcKeyFile} ]; then
          ${lib.getExe' bindPkg "rndc-confgen"} -c ${bindRndcKeyFile} -a -A ${bindRndcMacType} 2>/dev/null
        fi
      '';

      serviceConfig = {
        Type = "forking"; # Set type to forking, see https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=900788
        ExecStart = "${bindNamedExe} ${lib.optionalString cfg.ipv4Only "-4"} -c ${cfg.configFile} ${lib.concatStringsSep " " cfg.extraArgs}";
        ExecReload = "${bindRndcExe} -k '${bindRndcKeyFile}' reload";
        ExecStop = "${bindRndcExe} -k '${bindRndcKeyFile}' stop";
        User = bindUser;
        RuntimeDirectory = "named";
        RuntimeDirectoryPreserve = "yes";
        ConfigurationDirectory = "bind";
        ReadWritePaths = [
          (lib.mapAttrsToList (
            name: config: if (lib.hasPrefix "/" config.file) then "-${dirOf config.file}" else ""
          ) cfg.zones)
          cfg.directory
        ];
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ReadOnlyPaths = "/sys";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6 AF_NETLINK" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@mount @debug @clock @reboot @resources @privileged @obsolete acct modify_ldt add_key adjtimex clock_adjtime delete_module fanotify_init finit_module get_mempolicy init_module io_destroy io_getevents iopl ioperm io_setup io_submit io_cancel kcmp kexec_load keyctl lookup_dcookie migrate_pages move_pages open_by_handle_at perf_event_open process_vm_readv process_vm_writev ptrace remap_file_pages request_key set_mempolicy swapoff swapon uselib vmsplice";
      };

      unitConfig.Documentation = "man:named(8)";
    };
  };
}
