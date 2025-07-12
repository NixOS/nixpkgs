{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.frr;

  daemons = [
    "bgpd"
    "ospfd"
    "ospf6d"
    "ripd"
    "ripngd"
    "isisd"
    "pimd"
    "pim6d"
    "ldpd"
    "nhrpd"
    "eigrpd"
    "babeld"
    "sharpd"
    "pbrd"
    "bfdd"
    "fabricd"
    "vrrpd"
    "pathd"
  ];

  daemonDefaultOptions = {
    zebra = "-A 127.0.0.1 -s 90000000";
    mgmtd = "-A 127.0.0.1";
    bgpd = "-A 127.0.0.1";
    ospfd = "-A 127.0.0.1";
    ospf6d = "-A ::1";
    ripd = "-A 127.0.0.1";
    ripngd = "-A ::1";
    isisd = "-A 127.0.0.1";
    pimd = "-A 127.0.0.1";
    pim6d = "-A ::1";
    ldpd = "-A 127.0.0.1";
    nhrpd = "-A 127.0.0.1";
    eigrpd = "-A 127.0.0.1";
    babeld = "-A 127.0.0.1";
    sharpd = "-A 127.0.0.1";
    pbrd = "-A 127.0.0.1";
    staticd = "-A 127.0.0.1";
    bfdd = "-A 127.0.0.1";
    fabricd = "-A 127.0.0.1";
    vrrpd = "-A 127.0.0.1";
    pathd = "-A 127.0.0.1";
  };

  renamedServices = [
    "bgp"
    "ospf"
    "ospf6"
    "rip"
    "ripng"
    "isis"
    "pim"
    "ldp"
    "nhrp"
    "eigrp"
    "babel"
    "sharp"
    "pbr"
    "bfd"
    "fabric"
  ];

  obsoleteServices = renamedServices ++ [
    "static"
    "mgmt"
    "zebra"
  ];

  allDaemons = builtins.attrNames daemonDefaultOptions;

  isEnabled = service: cfg.${service}.enable;

  daemonLine = d: "${d}=${if isEnabled d then "yes" else "no"}";

  configFile =
    if cfg.configFile != null then
      cfg.configFile
    else
      pkgs.writeText "frr.conf" ''
        ! FRR configuration
        !
        hostname ${config.networking.hostName}
        log syslog
        service password-encryption
        service integrated-vtysh-config
        !
        ${cfg.config}
        !
        end
      '';

  serviceOptions =
    service:
    {
      options = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ daemonDefaultOptions.${service} ];
        description = ''
          Options for the FRR ${service} daemon.
        '';
      };
      extraOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = ''
          Extra options to be appended to the FRR ${service} daemon options.
        '';
      };
    }
    // (
      if (builtins.elem service daemons) then { enable = lib.mkEnableOption "FRR ${service}"; } else { }
    );

in

{

  ###### interface
  imports =
    [
      {
        options.services.frr = {
          configFile = lib.mkOption {
            type = lib.types.nullOr lib.types.path;
            default = null;
            example = "/etc/frr/frr.conf";
            description = ''
              Configuration file to use for FRR.
              By default the NixOS generated files are used.
            '';
          };
          config = lib.mkOption {
            type = lib.types.lines;
            default = "";
            example = ''
              router rip
                network 10.0.0.0/8
              router ospf
                network 10.0.0.0/8 area 0
              router bgp 65001
                neighbor 10.0.0.1 remote-as 65001
            '';
            description = ''
              FRR configuration statements.
            '';
          };
          openFilesLimit = lib.mkOption {
            type = lib.types.ints.unsigned;
            default = 1024;
            description = ''
              This is the maximum number of FD's that will be available.  Use a
              reasonable value for your setup if you are expecting a large number
              of peers in say BGP.
            '';
          };
        };
      }
      { options.services.frr = (lib.genAttrs allDaemons serviceOptions); }
      (lib.mkRemovedOptionModule [ "services" "frr" "zebra" "enable" ] "FRR zebra is always enabled")
    ]
    ++ (map (
      d: lib.mkRenamedOptionModule [ "services" "frr" d "enable" ] [ "services" "frr" "${d}d" "enable" ]
    ) renamedServices)
    ++ (map
      (
        d:
        lib.mkRenamedOptionModule
          [ "services" "frr" d "extraOptions" ]
          [ "services" "frr" "${d}d" "extraOptions" ]
      )
      (
        renamedServices
        ++ [
          "static"
          "mgmt"
        ]
      )
    )
    ++ (map (d: lib.mkRemovedOptionModule [ "services" "frr" d "enable" ] "FRR ${d}d is always enabled")
      [
        "static"
        "mgmt"
      ]
    )
    ++ (map (
      d:
      lib.mkRemovedOptionModule [
        "services"
        "frr"
        d
        "config"
      ] "FRR switched to integrated-vtysh-config, please use services.frr.config"
    ) obsoleteServices)
    ++ (map (
      d:
      lib.mkRemovedOptionModule [ "services" "frr" d "configFile" ]
        "FRR switched to integrated-vtysh-config, please use services.frr.config or services.frr.configFile"
    ) obsoleteServices)
    ++ (map (
      d:
      lib.mkRemovedOptionModule [
        "services"
        "frr"
        d
        "vtyListenAddress"
      ] "Please change -A option in services.frr.${d}.options instead"
    ) obsoleteServices)
    ++ (map (
      d:
      lib.mkRemovedOptionModule [ "services" "frr" d "vtyListenPort" ]
        "Please use `-P «vtyListenPort»` option with services.frr.${d}.extraOptions instead, or change services.frr.${d}.options accordingly"
    ) obsoleteServices);

  ###### implementation

  config =
    let
      daemonList = lib.concatStringsSep "\n" (map daemonLine daemons);
      daemonOptionLine =
        d: "${d}_options=\"${lib.concatStringsSep " " (cfg.${d}.options ++ cfg.${d}.extraOptions)}\"";
      daemonOptions = lib.concatStringsSep "\n" (map daemonOptionLine allDaemons);
    in
    lib.mkIf (lib.any isEnabled daemons || cfg.configFile != null || cfg.config != "") {

      environment.systemPackages = [
        pkgs.frr # for the vtysh tool
      ];

      users.users.frr = {
        description = "FRR daemon user";
        isSystemUser = true;
        group = "frr";
      };

      users.groups = {
        frr = { };
        # Members of the frrvty group can use vtysh to inspect the FRR daemons
        frrvty = {
          members = [ "frr" ];
        };
      };

      environment.etc = {
        "frr/frr.conf".source = configFile;
        "frr/vtysh.conf".text = ''
          service integrated-vtysh-config
        '';
        "frr/daemons".text = ''
          # This file tells the frr package which daemons to start.
          #
          # The watchfrr, zebra and staticd daemons are always started.
          #
          # This part is auto-generated from services.frr.<daemon>.enable config
          ${daemonList}

          # If this option is set the /etc/init.d/frr script automatically loads
          # the config via "vtysh -b" when the servers are started.
          #
          vtysh_enable=yes

          # This part is auto-generated from services.frr.<daemon>.options or
          # services.frr.<daemon>.extraOptions
          ${daemonOptions}
        '';
      };

      systemd.tmpfiles.rules = [ "d /run/frr 0755 frr frr -" ];

      systemd.services.frr = {
        description = "FRRouting";
        documentation = [ "https://frrouting.readthedocs.io/en/latest/setup.html" ];
        wants = [ "network.target" ];
        after = [
          "network-pre.target"
          "systemd-sysctl.service"
        ];
        before = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        startLimitIntervalSec = 180;
        reloadIfChanged = true;
        restartTriggers = [
          configFile
          daemonList
        ];
        serviceConfig = {
          Nice = -5;
          Type = "forking";
          NotifyAccess = "all";
          TimeoutSec = 120;
          WatchdogSec = 60;
          RestartSec = 5;
          Restart = "always";
          LimitNOFILE = cfg.openFilesLimit;
          PIDFile = "/run/frr/watchfrr.pid";
          ExecStart = "${pkgs.frr}/libexec/frr/frrinit.sh start";
          ExecStop = "${pkgs.frr}/libexec/frr/frrinit.sh stop";
          ExecReload = "${pkgs.frr}/libexec/frr/frrinit.sh reload";
        };
        unitConfig = {
          StartLimitBurst = "3";
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ woffs ];
}
