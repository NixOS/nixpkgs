{
  krunkit,
  lib,
  nixos,
  pkgs,
  runCommand,
}:

let
  linuxPkgs = import pkgs.path {
    system = "aarch64-linux";
  };

  nixosConfig =
    (nixos {
      nixpkgs.pkgs = linuxPkgs;

      imports = [ "${pkgs.path}/nixos/modules/profiles/qemu-guest.nix" ];

      boot = {
        kernelParams = [ "console=hvc0" ];
        loader = {
          efi.canTouchEfiVariables = false;
          systemd-boot.enable = true;
        };
      };

      documentation.enable = false;
      environment.defaultPackages = [ ];

      fileSystems = {
        "/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };

        "/boot" = {
          device = "/dev/disk/by-label/ESP";
          fsType = "vfat";
        };
      };

      systemd.services.krunkit-boot-ok = {
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";
        script = ''
          echo krunkit-boot-ok >/dev/hvc0
        '';
      };

      system.stateVersion = lib.trivial.release;
    }).config;

  image = import "${pkgs.path}/nixos/lib/make-disk-image.nix" {
    inherit lib;
    config = nixosConfig;
    pkgs = linuxPkgs;

    additionalSpace = "64M";
    baseName = "krunkit-nixos";
    bootSize = "128M";
    copyChannel = false;
    format = "raw";
    partitionTableType = "efi";
  };
in
runCommand "krunkit-nixos-boot-test"
  {
    requiredSystemFeatures = [ "apple-virt" ];

    meta.platforms = [ "aarch64-darwin" ];
  }
  ''
    image=${image}/krunkit-nixos.img
    disk=$TMPDIR/disk.img
    console=$TMPDIR/console.log
    log=$TMPDIR/krunkit.log

    cp "$image" "$disk"
    chmod u+w "$disk"
    touch "$console" "$log"

    cleanup() {
      set +e
      if [ -n "''${pid:-}" ]; then
        kill "$pid" >/dev/null 2>&1
        for _ in $(seq 1 20); do
          kill -0 "$pid" >/dev/null 2>&1 || break
          sleep 1
        done
        kill -KILL "$pid" >/dev/null 2>&1
      fi
    }
    trap cleanup EXIT

    ${krunkit}/bin/krunkit \
      --cpus 1 \
      --memory 1024 \
      --log-file "$log" \
      --device "virtio-blk,path=$disk,format=raw" \
      --device "virtio-serial,logFilePath=$console" &
    pid=$!

    for _ in $(seq 1 120); do
      if grep -q krunkit-boot-ok "$console"; then
        touch "$out"
        exit 0
      fi

      if ! kill -0 "$pid" >/dev/null 2>&1; then
        echo "krunkit exited before the guest reached multi-user.target"
        wait "$pid"
        cat "$log"
        cat "$console"
        exit 1
      fi

      sleep 1
    done

    echo "timed out waiting for krunkit guest boot marker"
    cat "$log"
    cat "$console"
    exit 1
  ''
