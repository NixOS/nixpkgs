{ config, lib, pkgs, ... }:

with lib;
with builtins;

let
  cfg = config.virtualisation;

  sanitizeImageName = image: replaceStrings ["/"] ["-"] image.imageName;
  hash = drv: head (split "-" (baseNameOf drv.outPath));
  # The label of an ext4 FS is limited to 16 bytes
  labelFromImage = image: substring 0 16 (hash image);

  # The Docker image is loaded and some files from /var/lib/docker/
  # are written into a qcow image.
  preload = image: pkgs.vmTools.runInLinuxVM (
    pkgs.runCommand "docker-preload-image-${sanitizeImageName image}" {
      buildInputs = with pkgs; [ docker e2fsprogs utillinux curl kmod ];
      preVM = pkgs.vmTools.createEmptyImage {
        size = cfg.dockerPreloader.qcowSize;
        fullName = "docker-deamon-image.qcow2";
      };
    }
    ''
      mkfs.ext4 /dev/vda
      e2label /dev/vda ${labelFromImage image}
      mkdir -p /var/lib/docker
      mount -t ext4 /dev/vda /var/lib/docker

      modprobe overlay

      # from https://github.com/tianon/cgroupfs-mount/blob/master/cgroupfs-mount
      mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
      cd /sys/fs/cgroup
      for sys in $(awk '!/^#/ { if ($4 == 1) print $1 }' /proc/cgroups); do
        mkdir -p $sys
        if ! mountpoint -q $sys; then
          if ! mount -n -t cgroup -o $sys cgroup $sys; then
            rmdir $sys || true
          fi
        fi
      done

      dockerd -H tcp://127.0.0.1:5555 -H unix:///var/run/docker.sock &

      until $(curl --output /dev/null --silent --connect-timeout 2 http://127.0.0.1:5555); do
        printf '.'
        sleep 1
      done

      docker load -i ${image}

      kill %1
      find /var/lib/docker/ -maxdepth 1 -mindepth 1 -not -name "image" -not -name "overlay2" | xargs rm -rf
    '');

  preloadedImages = map preload cfg.dockerPreloader.images;

in

{
  options.virtualisation.dockerPreloader = {
    images = mkOption {
      default = [ ];
      type = types.listOf types.package;
      description =
      ''
        A list of Docker images to preload (in the /var/lib/docker directory).
      '';
    };
    qcowSize = mkOption {
      default = 1024;
      type = types.int;
      description =
      ''
        The size (MB) of qcow files.
      '';
    };
  };

  config = mkIf (cfg.dockerPreloader.images != []) {
    assertions = [{
      # If docker.storageDriver is null, Docker choose the storage
      # driver. So, in this case, we cannot be sure overlay2 is used.
      assertion = cfg.docker.storageDriver == "overlay2"
        || cfg.docker.storageDriver == "overlay"
        || cfg.docker.storageDriver == null;
      message = "The Docker image Preloader only works with overlay2 storage driver!";
    }];

    virtualisation.qemu.options =
      map (path: "-drive if=virtio,file=${path}/disk-image.qcow2,readonly,media=cdrom,format=qcow2")
      preloadedImages;


    # All attached QCOW files are mounted and their contents are linked
    # to /var/lib/docker/ in order to make image available.
    systemd.services.docker-preloader = {
      description = "Preloaded Docker images";
      wantedBy = ["docker.service"];
      after = ["network.target"];
      path = with pkgs; [ mount rsync jq ];
      script = ''
        mkdir -p /var/lib/docker/overlay2/l /var/lib/docker/image/overlay2
        echo '{}' > /tmp/repositories.json

        for i in ${concatStringsSep " " (map labelFromImage cfg.dockerPreloader.images)}; do
          mkdir -p /mnt/docker-images/$i

          # The ext4 label is limited to 16 bytes
          mount /dev/disk/by-label/$(echo $i | cut -c1-16) -o ro,noload /mnt/docker-images/$i

          find /mnt/docker-images/$i/overlay2/ -maxdepth 1 -mindepth 1 -not -name l\
             -exec ln -s '{}' /var/lib/docker/overlay2/ \;
          cp -P /mnt/docker-images/$i/overlay2/l/* /var/lib/docker/overlay2/l/

          rsync -a /mnt/docker-images/$i/image/ /var/lib/docker/image/

          # Accumulate image definitions
          cp /tmp/repositories.json /tmp/repositories.json.tmp
          jq -s '.[0] * .[1]' \
            /tmp/repositories.json.tmp \
            /mnt/docker-images/$i/image/overlay2/repositories.json \
            > /tmp/repositories.json
        done

        mv /tmp/repositories.json /var/lib/docker/image/overlay2/repositories.json
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };
  };
}
