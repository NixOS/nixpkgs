{lib, pkgs, config, ...}:

let
  cfg = config.networking.ib-interfaces;
  systemd = config.systemd.package;
in {

  options = {
    networking.ib-interfaces = {
      enable = lib.mkEnableOption "ib-interfaces";
      configDir = lib.mkOption {
        default = "${pkgs.rdma-core}/etc/rdma/modules";
        type = lib.types.path;
        description = "The directory containing rdma kernel module configuration files";
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ pkgs.rdma-core ];
    services.udev.packages =
      let patchedUdevRules = pkgs.stdenv.mkDerivation {
        name = "patched-${pkgs.rdma-core.name}-udev-rules";
        src = "${pkgs.rdma-core}/lib/udev/rules.d";
        phases = ["unpackPhase" "patchPhase" "installPhase"];
        patchPhase = ''
          substituteInPlace 60-srp_daemon.rules \
            --replace /bin/systemctl ${systemd}/bin/systemctl
        '';
        installPhase = ''
          mkdir -p $out/lib/udev/rules.d
          cp -r . $out/lib/udev/rules.d/
        '';
      }; in [ patchedUdevRules ];


    # This unit is reproduced from "${rdma-core}/lib/systemd/system/rdma-load-modules@.service";
    systemd.services."rdma-load-modules@" = {
      description="Load RDMA modules from ${cfg.configDir}";
      conflicts = ["shutdown.target"];
      wants = ["network-pre.target"];

      before = [
        # Kernel module loading must take place before sysinit.target, similar to
        # systemd-modules-load.service
        "sysinit.target"

        # Do not execute concurrently with an ongoing shutdown
        "shutdown.target"

        # Partially support distro network setup scripts that run after
        # systemd-modules-load.service but before sysinit.target, eg a classic network
        # setup script. Run them after modules have loaded.
        "network-pre.target"

        # Orders all kernel module startup before rdma-hw.target can become ready
        "rdma-hw.target"
      ];

      unitConfig = {
        enable = false;
        DefaultDependencies="no";
        ConditionCapability="CAP_SYS_MODULE";
      };

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${systemd}/lib/systemd/systemd-modules-load ${cfg.configDir}/%I.conf";
        TimeoutSec = 90;
      };
    };

    # Units files pulled straight from the rdma-core package
    systemd.units = let
      mkUnit = name: lib.nameValuePair name ({
        unit = pkgs.runCommand "unit" { preferLocalBuild = true; } ''
          mkdir -p $out
          ln -s ${pkgs.rdma-core}/lib/systemd/system/${name} $out/${name}
        '';
      });
    in lib.listToAttrs (map mkUnit [
      "ibacm.socket"
      "iwpmd.service"
      "rdma-hw.target"
      "rdma-ndd.service"
      "srp_daemon_port@.service"
      "srp_daemon.service"
    ]);
  };
}
