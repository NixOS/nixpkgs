{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.proton-vpn;
  apiPackage = pkgs.python3Packages.proton-vpn-api-core;
  daemonPackage = pkgs.python3Packages.proton-vpn-daemon;
  kernel = config.boot.kernelPackages.kernel;
  kernelDir = "${kernel.dev}/lib/modules/${kernel.modDirVersion}";
  kernelHeaders = pkgs.symlinkJoin {
    name = "proton-vpn-kernel-headers-${kernel.modDirVersion}";
    # BCC expects a single tree containing both generated and source headers.
    paths = [
      "${kernelDir}/build"
      "${kernelDir}/source"
    ];
  };
in
{
  options.programs.proton-vpn = {
    gui = {
      enable = lib.mkEnableOption "the Proton VPN graphical application";
      package = lib.mkPackageOption pkgs "proton-vpn" { } // {
        default = pkgs.proton-vpn.override {
          withSplitTunneling = cfg.splitTunneling.enable;
        };
        defaultText = lib.literalExpression ''
          pkgs.proton-vpn.override {
            withSplitTunneling = config.programs.proton-vpn.splitTunneling.enable;
          }
        '';
      };
    };

    protonProtocols.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.gui.enable;
      defaultText = lib.literalExpression "config.programs.proton-vpn.gui.enable";
      description = ''
        Whether to register the Proton NetworkManager plugin for Stealth and
        Smart Protocol. Requires the GUI, as the CLI does not currently support
        these protocols.
      '';
    };

    splitTunneling.enable = lib.mkOption {
      type = lib.types.bool;
      default = cfg.gui.enable;
      defaultText = lib.literalExpression "config.programs.proton-vpn.gui.enable";
      description = ''
        Whether to enable the privileged split tunneling daemon, which uses BCC
        and matching kernel headers to load eBPF programs. Split tunneling is
        currently supported by the GUI and requires it to be enabled.
      '';
    };

    cli = {
      enable = lib.mkEnableOption "the Proton VPN command-line application";
      package = lib.mkPackageOption pkgs "proton-vpn-cli" { };
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = cfg.protonProtocols.enable -> cfg.gui.enable;
          message = "programs.proton-vpn.protonProtocols.enable requires programs.proton-vpn.gui.enable; the CLI does not currently support Stealth or Smart Protocol.";
        }
        {
          assertion = cfg.splitTunneling.enable -> cfg.gui.enable;
          message = "programs.proton-vpn.splitTunneling.enable requires programs.proton-vpn.gui.enable; the CLI does not currently support split tunneling.";
        }
      ];
    }
    (lib.mkIf (cfg.gui.enable || cfg.cli.enable) (
      lib.mkMerge [
        {
          environment.systemPackages =
            lib.optional cfg.gui.enable cfg.gui.package ++ lib.optional cfg.cli.enable cfg.cli.package;

          networking.networkmanager.enable = true;
        }

        (lib.mkIf cfg.protonProtocols.enable {
          networking.networkmanager.plugins = [ apiPackage ];
        })

        (lib.mkIf cfg.splitTunneling.enable {
          services.dbus.packages = [ daemonPackage ];
          systemd.packages = [ daemonPackage ];
          systemd.services."me.proton.vpn.split_tunneling" = {
            wantedBy = [ "multi-user.target" ];
            path = [ pkgs.kmod ];
            environment.BCC_KERNEL_SOURCE = "${kernelHeaders}";
          };
        })
      ]
    ))
  ];

  meta.maintainers = with lib.maintainers; [ schembriaiden ];
}
