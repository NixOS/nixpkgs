# Runs a NixOS guest on Apple's Virtualization.framework with `vzvm`: Rosetta, and a
# lighter hypervisor than QEMU.
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation;
  vzCfg = cfg.vz;

  hostPkgs = cfg.host.pkgs;

  inherit
    (import ../../lib/store-registration-info.nix {
      inherit hostPkgs;
      rootPaths = cfg.additionalPaths;
    })
    regInfo
    regInfoPath
    ;

  # Host-built erofs store image, named by closure hash so only a changed guest rebuilds it.
  # A derivation is not an option: it would need the Linux builder this VM provides.
  storeClosureInfo = hostPkgs.closureInfo {
    rootPaths = [
      config.system.build.toplevel
      regInfo
    ];
  };
  storeImageName = "store-${lib.head (lib.splitString "-" (baseNameOf (toString storeClosureInfo)))}.img";

  toplevel = config.system.build.toplevel;

  kernelParams = [
    # Virtualization.framework offers a virtio console
    "console=hvc0"
    "init=${toplevel}/init"
    "regInfo=${regInfoPath}"
  ]
  ++ config.boot.kernelParams;

  forwards = map (forward: {
    listen = "${forward.host.address}:${toString forward.host.port}";
    vsockPort = forward.guest.port;
  }) vzCfg.forwardPorts;

  # The builder profile passes the keys directory as `"$KEYS"`; the runner resolves it.
  shareFragment = lib.concatMapStrings (share: ''
    shares=$(${lib.getExe hostPkgs.jq} -n --argjson shares "$shares" \
      --arg tag ${lib.escapeShellArg share.tag} --arg path ${share.source} \
      '$shares + [{tag: $tag, path: $path}]')
  '') (lib.attrValues cfg.sharedDirectories);

  staticConfig = {
    cpuCount = cfg.cores;
    memorySizeMiB = cfg.memorySize;
    kernel = "${toplevel}/kernel";
    initrd = "${toplevel}/initrd";
    cmdline = toString kernelParams;
    vsock.forwards = forwards;
    rosetta = vzCfg.rosetta.enable;
    inherit (vzCfg) nestedVirtualization;
    # Only `file` carries a path; dispatch rather than fall through, so a new mode cannot
    # silently be emitted as `file`.
    console =
      if vzCfg.console == "file" then
        {
          mode = "file";
          path = vzCfg.consoleLog;
        }
      else
        { mode = vzCfg.console; };
  }
  // vzCfg.extraConfig;

  staticConfigFile = hostPkgs.writeText "vzvm-config.json" (builtins.toJSON staticConfig);
in
{
  imports = [ ./vm-base.nix ];

  options = {

    virtualisation.vz.package = lib.mkPackageOption hostPkgs "vzvm" { };

    virtualisation.vz.rosetta = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Expose Rosetta to the guest, so that it can execute x86_64 binaries.

          Rosetta must be installed on the host; the VM refuses to start
          otherwise rather than quietly losing the ability to build for
          x86_64-linux. Install it with:

          ```
          softwareupdate --install-rosetta --agree-to-license
          ```
        '';
      };

    };

    virtualisation.vz.nestedVirtualization = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Boot the guest at EL2 so it gets a working `/dev/kvm`, which the Nix
        daemon inside then advertises as the `kvm` system feature — required
        for running NixOS integration tests on the builder.

        Needs macOS 15+ and an M3 or newer chip; the VM refuses to start
        otherwise rather than quietly advertising a `kvm` it does not have.
      '';
    };

    virtualisation.vz.forwardPorts = lib.mkOption {
      type = lib.types.listOf (
        lib.types.submodule {
          options.host.address = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Host address to listen on.";
          };
          options.host.port = lib.mkOption {
            type = lib.types.port;
            description = "Host port to listen on.";
          };
          options.guest.port = lib.mkOption {
            type = lib.types.port;
            description = "Guest *vsock* port that connections are forwarded to.";
          };
        }
      );
      default = [ ];
      example = lib.literalExpression ''
        [ { host.port = 2222; guest.port = 22; } ]
      '';
      description = ''
        Forward host TCP ports into guest over vsock.

        Going via vsock relieves us from having to find a stable inbound address
        in the NAT network setup.
      '';
    };

    virtualisation.vz.console = lib.mkOption {
      type = lib.types.enum [
        "stdio"
        "file"
        "log"
      ];
      default = "stdio";
      description = ''
        Where the guest console goes.

        - `stdio`: standard output, which is interactive but goes nowhere under launchd.
        - `file`: the path in {option}`virtualisation.vz.consoleLog`. The only complete
          record: the unified log rate-limits chatty sources and drops under bursts.
        - `log`: macOS unified logging, alongside vzvm's own diagnostics. Read it with
          `log show --predicate 'subsystem == "systems.applicative.vzvm"'`, and narrow to
          the guest with `AND category == "guest"`.
      '';
    };

    virtualisation.vz.consoleLog = lib.mkOption {
      type = lib.types.str;
      default = "./console.log";
      description = ''
        Console log file, used when {option}`virtualisation.vz.console` is `file`.
        Relative paths are resolved against working directory.
      '';
    };

    virtualisation.vz.diskImage = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = "./${config.system.name}.img";
      defaultText = lib.literalExpression ''"./''${config.system.name}.img"'';
      description = ''
        Path to the raw data disk backing the writable store, created on first
        start. Set to `null` to run without one, which requires
        {option}`virtualisation.writableStoreUseTmpfs`.
      '';
    };

    virtualisation.vz.extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        Additional attributes merged into the generated `vzvm` JSON configuration.
      '';
    };
  };

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = hostPkgs.stdenv.hostPlatform.system == "aarch64-darwin";
          message = ''
            virtualisation.vz only runs on aarch64-darwin hosts, but
            `virtualisation.host.pkgs` is ${hostPkgs.stdenv.hostPlatform.system}.
          '';
        }
        {
          assertion = pkgs.stdenv.hostPlatform.isAarch64;
          message = ''
            virtualisation.vz cannot emulate a foreign architecture: the guest
            (${pkgs.stdenv.hostPlatform.system}) must be aarch64. x86_64 guest
            binaries run through Rosetta instead, not through emulation.
          '';
        }
        {
          assertion = vzCfg.diskImage != null || cfg.writableStoreUseTmpfs;
          message = ''
            virtualisation.vz.diskImage is null, so there is nowhere to put the
            writable store. Enable virtualisation.writableStoreUseTmpfs.
          '';
        }
      ];

      boot.loader.grub.enable = false;

      boot.initrd.availableKernelModules = [
        "virtio_pci"
        "virtio_blk"
        "virtio_console"
        "virtiofs"
        "erofs"
        "overlay"
      ];

      # Inbound connections go via vsock; loaded in the initrd so `systemd-ssh-generator` finds `/dev/vsock`.
      boot.initrd.kernelModules = [ "vmw_vsock_virtio_transport" ];

      boot.initrd.systemd.enable = lib.mkDefault true;

      system.requiredKernelConfig = with config.lib.kernelConfig; [
        (isEnabled "VIRTIO_BLK")
        (isEnabled "VIRTIO_PCI")
        (isEnabled "VIRTIO_CONSOLE")
        (isEnabled "VIRTIO_NET")
        (isYes "BLK_DEV_INITRD")
        (isEnabled "FUSE_FS")
        (isEnabled "VIRTIO_FS")
        (isEnabled "EROFS_FS")
        (isEnabled "OVERLAY_FS")
        (isEnabled "VSOCKETS")
        (isEnabled "VIRTIO_VSOCKETS")
      ];

      # Override per entry and not as a whole: see note in vm-base.nix.
      fileSystems = {
        "/" = lib.mkVMOverride {
          device = "tmpfs";
          fsType = "tmpfs";
          neededForBoot = true;
          options = [ "mode=0755" ];
        };
      }
      // lib.optionalAttrs (!cfg.writableStoreUseTmpfs && vzCfg.diskImage != null) {
        # Second disk, hence /dev/vdb: store image is always first. Mount all of
        # /nix so the Nix database persists together with the writable store.
        "/nix" = lib.mkVMOverride {
          device = "/dev/vdb";
          fsType = "ext4";
          autoFormat = true;
          neededForBoot = true;
        };
      }
      // lib.mapAttrs' (
        _: share:
        lib.nameValuePair share.target (
          lib.mkVMOverride {
            device = share.tag;
            fsType = "virtiofs";
          }
        )
      ) cfg.sharedDirectories;

      # DHCP and DNS come from host NAT
      networking.useDHCP = lib.mkDefault true;

      virtualisation.rosetta.enable = lib.mkIf vzCfg.rosetta.enable true;
      # Must agree with the tag vzvm shares Rosetta under, which is fixed.
      virtualisation.rosetta.mountTag = lib.mkIf vzCfg.rosetta.enable "rosetta";

      system.build.vm =
        hostPkgs.runCommand "nixos-vm"
          {
            preferLocalBuild = true;
            meta.mainProgram = "run-${config.system.name}-vm";
          }
          ''
            mkdir -p $out/bin
            ln -s ${config.system.build.toplevel} $out/system
            ln -s ${hostPkgs.writeShellScript "run-${config.system.name}-vm" ''
              set -eu

              # nix-darwin runs this with a working directory it owns
              imageDir="''${VZVM_STATE_DIR:-$PWD}"
              mkdir -p "$imageDir"

              if [ -z "''${TMPDIR:-}" ]; then
                # GNU mktemp needs the XXXXXX placeholder; only reachable when TMPDIR is unset.
                TMPDIR=$(${hostPkgs.coreutils}/bin/mktemp -d -t vzvm.XXXXXX)
              fi
              export TMPDIR

              ${lib.optionalString cfg.useHostCerts ''
                mkdir -p "$TMPDIR/certs"
                if [ -e "''${NIX_SSL_CERT_FILE:-}" ]; then
                  ${hostPkgs.coreutils}/bin/install -m 0644 \
                    "$NIX_SSL_CERT_FILE" "$TMPDIR/certs/ca-certificates.crt"
                else
                  echo "vzvm: NIX_SSL_CERT_FILE is unset or missing; guest gets no host CA certificates" >&2
                  : > "$TMPDIR/certs/ca-certificates.crt"
                fi
              ''}

              storeImage="$imageDir/${storeImageName}"

              if [ ! -f "$storeImage" ]; then
                echo "Building Nix store image, this can take a minute on first boot..." >&2

                # Build into a temp file so an interrupted run leaves no truncated image behind.
                storeImageTmp="$storeImage.tmp.$$"
                # shellcheck disable=SC2064
                trap "rm -f '$storeImageTmp'" EXIT

                ${import ../../lib/erofs-store-image.nix {
                  inherit hostPkgs;
                  storePaths = "${storeClosureInfo}/store-paths";
                  label = "nix-store";
                  destination = ''"$storeImageTmp"'';
                }}
                mv "$storeImageTmp" "$storeImage"
                trap - EXIT

                # Images from previous generations are dead weight and cheap to rebuild.
                find "$imageDir" -maxdepth 1 -name 'store-*.img' ! -name ${lib.escapeShellArg storeImageName} -delete
              fi

              disks=$(${lib.getExe hostPkgs.jq} -n --arg store "$storeImage" \
                '[{path: $store, readOnly: true}]')

              shares='[]'
              ${shareFragment}

              ${lib.optionalString (vzCfg.diskImage != null) ''
                dataDisk="${vzCfg.diskImage}"
                case "$dataDisk" in
                  /*) ;;
                  *) dataDisk="$imageDir/''${dataDisk#./}" ;;
                esac

                if [ ! -f "$dataDisk" ]; then
                  echo "Creating ${toString cfg.diskSize}M data disk at $dataDisk..." >&2
                  ${hostPkgs.coreutils}/bin/dd if=/dev/zero of="$dataDisk" bs=1M count=0 \
                     seek=${toString cfg.diskSize}
                fi

                disks=$(${lib.getExe hostPkgs.jq} -n --argjson disks "$disks" --arg data "$dataDisk" \
                  '$disks + [{path: $data, readOnly: false}]')
              ''}

              config="$imageDir/vzvm.json"
              ${lib.getExe hostPkgs.jq} --argjson disks "$disks" --argjson shares "$shares" \
                '.disks = $disks | .shares = $shares' ${staticConfigFile} > "$config"

              exec ${lib.getExe vzCfg.package} "$config"
            ''} $out/bin/run-${config.system.name}-vm
          '';
    }

    (lib.mkIf config.services.openssh.enable {
      # `systemd-ssh-generator` serves SSH on vsock:22; retune its socket for `ssh-ng://` build traffic.
      systemd.sockets.sshd-vsock = {
        overrideStrategy = "asDropin";
        socketConfig = {
          # past the default 64 concurrent connections, systemd stops accepting and ssh hangs silently
          MaxConnections = 512;

          # don't stop the socket unit outright when connections arrive in bursts
          TriggerLimitIntervalSec = 0;
        };
      };

      systemd.services."sshd-vsock@" = {
        overrideStrategy = "asDropin";
        # don't race host key generation on first boot
        wants = [ "sshd-keygen.service" ];
        after = [ "sshd-keygen.service" ];
        serviceConfig.TimeoutStopSec = 10;
      };

      # vsock delivers no RST, so without keepalives a session whose peer vanished never dies.
      services.openssh.settings = {
        ClientAliveInterval = lib.mkDefault 60;
        ClientAliveCountMax = lib.mkDefault 3;
      };
    })

    (lib.mkIf cfg.useHostCerts {
      virtualisation.sharedDirectories.certs = {
        source = "$TMPDIR/certs";
        target = "/etc/ssl/certs";
      };
      security.pki.installCACerts = false;
    })
  ];
}
