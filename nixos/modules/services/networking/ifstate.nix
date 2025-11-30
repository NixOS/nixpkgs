{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.networking.ifstate;
  initrdCfg = config.boot.initrd.network.ifstate;
  settingsFormat = {
    # override generator in order to:
    # - use yq and not remarshal because it matches yaml datatype handling with IfState
    # - validate json schema
    generate =
      name: value: package:
      pkgs.runCommand name
        {
          nativeBuildInputs = with pkgs; [
            yq
            check-jsonschema
          ];
          value = builtins.toJSON value;
          passAsFile = [ "value" ];
        }
        ''
          yq --yaml-output . $valuePath > $out
          check-jsonschema --schemafile "${cfg.package.passthru.jsonschema}" "$out"
          sed -i $'s|\'!include |!include \'|' $out
        '';

    inherit (pkgs.formats.yaml { }) type;
  };
  initrdInterfaceTypes = builtins.map (interface: interface.link.kind) (
    builtins.attrValues initrdCfg.settings.interfaces
  );
  # IfState interface kind to kernel modules mapping
  interfaceKernelModules = {
    "ifb" = [ "ifb" ];
    "ip6tnl" = [ "ip6tnl" ];
    "ipoib" = [ "ib_ipoib" ];
    "ipvlan" = [ "ipvlan" ];
    "macvlan" = [ "macvlan" ];
    "macvtap" = [ "macvtap" ];
    "team" = [ "team" ];
    "tun" = [ "tun" ];
    "vrf" = [ "vrf" ];
    "vti" = [ "ip_vti" ];
    "vti6" = [ "ip6_vti" ];
    "bond" = [ "bonding" ];
    "bridge" = [ "bridge" ];
    # "physical" = ...;
    "dsa" = [ "dsa_core" ];
    "dummy" = [ "dummy" ];
    "veth" = [ "veth" ];
    "vxcan" = [ "vxcan" ];
    "vlan" = [ "8021q" ];
    "vxlan" = [ "vxlan" ];
    "ipip" = [ "ipip" ];
    "sit" = [ "sit" ];
    "gre" = [ "ip_gre" ];
    "gretap" = [ "ip_gre" ];
    "ip6gre" = [ "ip6_gre" ];
    "ip6gretap" = [ "ip6_gre" ];
    "geneve" = [ "geneve" ];
    "wireguard" = [ "wireguard" ];
    "xfrm" = [ "xfrm_interface" ];
  };
  # https://github.com/systemd/systemd/blob/main/units/systemd-networkd.service.in
  commonServiceConfig = {
    after = [
      "systemd-udev-settle.service"
      "network-pre.target"
      "systemd-sysusers.service"
      "systemd-sysctl.service"
    ];
    before = [
      "network.target"
      "multi-user.target"
      "shutdown.target"
      "initrd-switch-root.target"
    ];
    conflicts = [
      "shutdown.target"
      "initrd-switch-root.target"
    ];
    wants = [
      "network.target"
    ];

    unitConfig = {
      # Avoid default dependencies like "basic.target", which prevents ifstate from starting before luks is unlocked.
      DefaultDependencies = "no";
    };
  };
in
{
  meta.maintainers = with lib.maintainers; [ marcel ];

  options = {
    networking.ifstate = {
      enable = lib.mkEnableOption "networking using IfState";

      package = lib.mkPackageOption pkgs "ifstate" { };

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        default = { };
        description = "Content of IfState's configuration file. See <https://ifstate.net/2.0/schema/> for details.";
      };
    };

    boot.initrd.network.ifstate = {
      enable = lib.mkEnableOption "initrd networking using IfState";

      allowIfstateToDrasticlyIncreaseInitrdSize = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "IfState in initrd drastically increases the size of initrd, your boot partition may be too small and/or you may have significantly fewer generations. By setting this option, you acknowledge this fact and keep it in mind when reporting issues.";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = cfg.package.override {
          withConfigValidation = false;
        };
        defaultText = lib.literalExpression "pkgs.ifstate.override { withConfigValidation = false; }";
        description = "The initrd IfState package to use.";
      };

      settings = lib.mkOption {
        inherit (settingsFormat) type;
        default = { };
        description = "Content of IfState's initrd configuration file. See <https://ifstate.net/2.0/schema/> for details.";
      };

      cleanupSettings = lib.mkOption {
        inherit (settingsFormat) type;
        # required by json schema
        default.interfaces = { };
        description = "Content of IfState's initrd cleanup configuration file. See <https://ifstate.net/2.0/schema/> for details. This configuration gets applied before systemd switches to stage two. The goas is to deconfigurate the whole network in order to prevent access to services, before the firewall is configured. The stage two IfState configuration will start after the firewall is configured.";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !config.networking.networkmanager.enable;
          message = "IfState and NetworkManager cannot be used at the same time, as both configure the network in a conflicting manner.";
        }
        {
          assertion = !config.networking.useDHCP;
          message = "IfState and networking.useDHCP cannot be used at the same time, as both configure the network. Please look into IfState hooks to integrate DHCP: https://codeberg.org/liske/ifstate/issues/111";
        }
      ];

      networking.useDHCP = lib.mkDefault false;

      # sane defaults to not let IfState work against the kernel
      boot.extraModprobeConfig = ''
        options bonding max_bonds=0
        options dummy numdummies=0
        options ifb numifbs=0
      '';

      environment = {
        # ifstatecli command should be available to use user, there are other useful subcommands like check or show
        systemPackages = [ cfg.package ];
        # match the default value of the --config flag of IfState
        etc."ifstate/ifstate.yaml".source = settingsFormat.generate "ifstate.yaml" cfg.settings cfg.package;
      };

      systemd.services.ifstate = commonServiceConfig // {
        description = "IfState";

        wantedBy = [
          "multi-user.target"
        ];

        # mount is always available on nixos, avoid adding additional store paths to the closure
        path = [ "/run/wrappers" ];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${lib.getExe cfg.package} --config ${
            config.environment.etc."ifstate/ifstate.yaml".source
          } apply";
          # because oneshot services do not have a timeout by default
          TimeoutStartSec = "2min";
        };
      };
    })
    (lib.mkIf initrdCfg.enable {
      assertions = [
        {
          assertion = initrdCfg.allowIfstateToDrasticlyIncreaseInitrdSize;
          message = "IfState in initrd drastically increases the size of initrd, your boot partition may be too small and/or you may have significantly fewer generations. By setting boot.initrd.network.initrd.allowIfstateToDrasticlyIncreaseInitrdSize to true, you acknowledge this fact and keep it in mind when reporting issues.";
        }
        {
          assertion = cfg.enable;
          message = "If IfState is used in initrd, it should also be used for the stage 2 system (networking.ifstate), as initrd IfState does not clean up the network stack like it was before after execution.";
        }
        {
          assertion = config.boot.initrd.systemd.enable;
          message = "IfState only supports systemd stage one. See `boot.initrd.systemd.enable` option.";
        }
      ];

      environment.etc = {
        "ifstate/ifstate.initrd.yaml".source =
          settingsFormat.generate "ifstate.initrd.yaml" initrdCfg.settings
            initrdCfg.package;
        "ifstate/ifstate.initrd-cleanup.yaml".source =
          settingsFormat.generate "ifstate.initrd-cleanup.yaml" initrdCfg.cleanupSettings
            initrdCfg.package;
      };

      boot.initrd = {
        network.udhcpc.enable = lib.mkDefault false;

        # automatic configuration of kernel modules of virtual interface types
        availableKernelModules =
          let
            enableModule =
              type:
              if builtins.hasAttr type interfaceKernelModules then interfaceKernelModules."${type}" else [ ];
          in
          lib.flatten (builtins.map enableModule initrdInterfaceTypes);

        systemd = {
          storePaths = [
            (pkgs.runCommand "ifstate-closure"
              {
                info = pkgs.closureInfo {
                  rootPaths = [
                    initrdCfg.package
                    # copy whole config closure, because it can reference other files using !include
                    config.environment.etc."ifstate/ifstate.initrd.yaml".source
                    config.environment.etc."ifstate/ifstate.initrd-cleanup.yaml".source
                  ];
                };
              }
              ''
                mkdir $out
                cat "$info"/store-paths | while read path; do
                  ln -s "$path" "$out/$(basename "$path")"
                done
              ''
            )
          ];

          # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/boot/networkd.nix#L3444
          additionalUpstreamUnits = [
            "network-online.target"
            "network-pre.target"
            "network.target"
            "nss-lookup.target"
            "nss-user-lookup.target"
            "remote-fs-pre.target"
            "remote-fs.target"
          ];

          services.ifstate-initrd = commonServiceConfig // {
            description = "IfState initrd";

            wantedBy = [
              "initrd.target"
            ];

            # mount is always available on nixos, avoid adding additional store paths to the closure
            # https://github.com/NixOS/nixpkgs/blob/2b8e2457ebe576ebf41ddfa8452b5b07a8d493ad/nixos/modules/system/boot/systemd/initrd.nix#L550-L551
            path = [
              config.boot.initrd.systemd.package.util-linux
            ];

            serviceConfig = {
              Type = "oneshot";
              # Otherwise systemd starts ifstate again, after the encryption password was entered by the user
              # and we are able to implement the cleanup using ExecStop rather than a separate unit.
              RemainAfterExit = true;
              ExecStart = "${lib.getExe initrdCfg.package} --config ${
                config.environment.etc."ifstate/ifstate.initrd.yaml".source
              } apply";
              ExecStop = "${lib.getExe initrdCfg.package} --config ${
                config.environment.etc."ifstate/ifstate.initrd-cleanup.yaml".source
              } apply";
              # because oneshot services do not have a timeout by default
              TimeoutStartSec = "2min";
            };
          };
        };
      };
    })
  ];
}
