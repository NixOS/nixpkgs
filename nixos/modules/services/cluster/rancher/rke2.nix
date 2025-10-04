{
  config,
  lib,
  mkRancherModule,
  ...
}:
let
  cfg = config.services.rke2;
  baseModule = mkRancherModule {
    name = "rke2";
    serviceSuffix = "-${cfg.role}"; # upstream default, used by rke2-killall.sh

    extraBinFlags =
      (lib.optional (cfg.cni != null) "--cni=${cfg.cni}")
      ++ (lib.optional cfg.cisHardening "--profile=${
        if cfg.package.version >= "1.25" then
          "cis"
        else if cfg.package.version >= "1.23" then
          "cis-1.23"
        else
          "cis-1.6"
      }");

    # RKE2 sometimes tries opening YAML manifests on start with O_RDWR, which we can't support
    # without ugly workarounds since they're linked from the read-only /nix/store.
    # https://github.com/brandond/rke2/blob/fa7ed3a87055830924d05009a1071acfbbfbcc2c/pkg/bootstrap/bootstrap.go#L355
    jsonManifests = true;
  };
in
{
  # interface

  options.services.rke2 = lib.recursiveUpdate baseModule.options {
    # option overrides
    role.description = ''
      Whether rke2 should run as a server or agent.

      If it's a server:

      - By default it also runs workloads as an agent.
      - All options can be set.

      If it's an agent:

      - `serverAddr` is required.
      - `token` or `tokenFile` is required.
      - `agentToken`, `agentTokenFile`, `disable` and `cni` should not be set.
    '';

    disable.description = ''
      Disable default components, see the [RKE2 documentation](https://docs.rke2.io/install/packaged_components#using-the---disable-flag).
    '';

    # rke2-specific options
    cni = lib.mkOption {
      type =
        with lib.types;
        nullOr (enum [
          "none"
          "canal"
          "cilium"
          "calico"
          "flannel"
        ]);
      description = ''
        CNI plugins to deploy, one of `none`, `calico`, `canal`, `cilium` or `flannel`.

        All CNI plugins get installed via a helm chart after the main components are up and running
        and can be [customized by modifying the helm chart options](https://docs.rke2.io/helm).

        [Learn more about RKE2 and CNI plugins](https://docs.rke2.io/networking/basic_network_options)

        > **WARNING**: Flannel support in RKE2 is currently experimental.
      '';
      default = null;
    };

    cisHardening = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Enable CIS Hardening for RKE2.

        The OS-level configuration options required to pass the CIS benchmark are enabled by default.
        This option only creates the `etcd` user and group, and passes the `--profile=cis` flag to RKE2.

        Learn more about [CIS Hardening for RKE2](https://docs.rke2.io/security/hardening_guide).
      '';
      default = false;
    };
  };

  # implementation

  config = lib.mkIf cfg.enable (
    lib.recursiveUpdate baseModule.config {
      warnings = (
        lib.optional (
          cfg.role == "agent" && cfg.cni != null
        ) "rke2: cni should not be set if role is 'agent'"
      );

      # Configure NetworkManager to ignore CNI network interfaces.
      # See: https://docs.rke2.io/known_issues#networkmanager
      environment.etc."NetworkManager/conf.d/rke2-canal.conf" = {
        enable = config.networking.networkmanager.enable;
        text = ''
          [keyfile]
          unmanaged-devices=interface-name:flannel*;interface-name:cali*;interface-name:tunl*;interface-name:vxlan.calico;interface-name:vxlan-v6.calico;interface-name:wireguard.cali;interface-name:wg-v6.cali
        '';
      };

      # CIS hardening
      # https://docs.rke2.io/security/hardening_guide#kernel-parameters
      # https://github.com/rancher/rke2/blob/ef0fc7aa9d3bbaa95ce9b1895972488cbd92e302/bundle/share/rke2/rke2-cis-sysctl.conf
      boot.kernel.sysctl = {
        "vm.panic_on_oom" = 0;
        "vm.overcommit_memory" = 1;
        "kernel.panic" = 10;
        "kernel.panic_on_oops" = 1;
      };
      # https://docs.rke2.io/security/hardening_guide#etcd-is-configured-properly
      users = lib.mkIf cfg.cisHardening {
        users.etcd = {
          isSystemUser = true;
          group = "etcd";
        };
        groups.etcd = { };
      };
    }
  );
}
