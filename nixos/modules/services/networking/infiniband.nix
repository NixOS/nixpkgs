{lib, pkgs, config, ...}:

let
  cfg = config.networking.ib-interfaces;
in {

  imports = [];

  options = {
    networking.ib-interfaces = {
      enable = lib.mkEnableOption "ib-interfaces";
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
            --replace /bin/systemctl ${pkgs.systemd}/bin/systemctl
        '';
        installPhase = ''
          mkdir -p $out/lib/udev/rules.d
          cp -r . $out/lib/udev/rules.d/
        '';
      }; in [ patchedUdevRules ];

    # Units
    systemd.units = with pkgs; {
      "ibacm.service".text =
        builtins.readFile "${rdma-core}/lib/systemd/system/ibacm.service";
      "ibacm.socket".text =
        builtins.readFile "${rdma-core}/lib/systemd/system/ibacm.socket";
      "iwpmd.service".text =
        builtins.readFile "${rdma-core}/lib/systemd/system/iwpmd.service";
      "rdma-hw.target".text =
        builtins.readFile "${rdma-core}/lib/systemd/system/rdma-hw.target";
      "rdma-load-modules@.service".text = ''
        [Unit]
        Description=Load RDMA modules from /nix/store/q38v9b228hiwavpnvfqgds42hfwqv6a3-rdma-core-25.0/etc/rdma/modules/%I.conf
        Documentation=file:/nix/store/q38v9b228hiwavpnvfqgds42hfwqv6a3-rdma-core-25.0/share/doc/udev.md
        # Kernel module loading must take place before sysinit.target, similar to
        # systemd-modules-load.service
        DefaultDependencies=no
        Before=sysinit.target
        # Do not execute concurrently with an ongoing shutdown
        Conflicts=shutdown.target
        Before=shutdown.target
        # Partially support distro network setup scripts that run after
        # systemd-modules-load.service but before sysinit.target, eg a classic network
        # setup script. Run them after modules have loaded.
        Wants=network-pre.target
        Before=network-pre.target
        # Orders all kernel module startup before rdma-hw.target can become ready
        Before=rdma-hw.target

        ConditionCapability=CAP_SYS_MODULE

        [Service]
        Type=oneshot
        RemainAfterExit=yes
        ExecStart=${pkgs.systemd}/lib/systemd/systemd-modules-load /nix/store/q38v9b228hiwavpnvfqgds42hfwqv6a3-rdma-core-25.0/etc/rdma/modules/%I.conf
        TimeoutSec=90s
      '';
      "rdma-ndd.service".text =
        builtins.readFile "${rdma-core}/lib/systemd/system/rdma-ndd.service";
      "srp_daemon_port@.service".text =
        builtins.readFile "${rdma-core}/lib/systemd/system/srp_daemon_port@.service";
      "srp_daemon.service".text =
        builtins.readFile "${rdma-core}/lib/systemd/system/srp_daemon.service";
    };
  };
}
