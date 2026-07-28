{ pkgs, lib, ... }:

{
  name = "rauc";

  nodes.machine =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (import ./ssh-keys.nix pkgs)
        snakeOilPrivateKey
        ;

      snakeOilRaucCert =
        pkgs.runCommand "rauc.crt"
          {
            inherit snakeOilPrivateKey;
          }
          ''
            ${lib.getExe pkgs.openssl} req -x509 -key $snakeOilPrivateKey -out $out -days 3650 \
              -addext subjectKeyIdentifier=hash \
              -addext authorityKeyIdentifier=keyid:always,issuer:always \
              -addext basicConstraints=CA:FALSE \
              -addext extendedKeyUsage=critical,codeSigning \
              -subj "/OU=Smoke Test/OU=RAUC/CN=NixOS/"
          '';

      raucManifest = pkgs.writeText "manifest.raucm" (
        lib.generators.toINI { } {
          update = {
            inherit (config.services.rauc) compatible;
            version = "@VERSION@";
          };
          bundle.format = "verity";
          "image.rauc".filename = "rauc.img";
        }
      );
      rauc-mkimg = pkgs.writeShellApplication {
        name = "rauc-mkimg";
        runtimeInputs = with pkgs; [
          config.services.rauc.package
          e2fsprogs
          squashfsTools
        ];

        text = ''
          set -xeuo pipefail
          tmpdir="$(mktemp -dt rauc.XXXXX)"

          cleanup() {
            rm -rf "$tmpdir"
          }
          trap cleanup EXIT

          cd "$tmpdir"
          mkdir bundle target
          cat ${raucManifest} > bundle/manifest.raucm
          sed -i "s/@VERSION@/$2/g" bundle/manifest.raucm
          echo "$1" > target/label
          truncate -s128M bundle/rauc.img
          mkfs.ext4 -v -L "rauc_$1" -d target bundle/rauc.img
          cd bundle
          rauc bundle --cert=${snakeOilRaucCert} --key=${snakeOilPrivateKey} . "$3"
        '';
      };
      rauc-bundle-c = pkgs.runCommand "rauc_c.bundle" { } ''
        ${lib.getExe rauc-mkimg} c 42 $out
      '';

      rauc-do-update = pkgs.writeShellScriptBin "rauc-do-update" ''
        if [ "$1" == c ]; then
          bundle=${rauc-bundle-c}
        else
          exit 1
        fi
        exec rauc install "$bundle"
      '';
    in
    {
      environment.systemPackages = with pkgs; [
        jq
        rauc-do-update
      ];

      services.rauc = {
        enable = true;
        client.enable = true;
        mark-good.enable = true;
        compatible = "nix/widget/smoketest";
        bootloader = "custom";
        slots = {
          rauc =
            let
              slot = ab: {
                enable = true;
                device = "/dev/vd${lib.replaceStrings [ "a" "b" ] [ "b" "c" ] ab}";
                settings.bootname = ab;
              };
            in
            [
              (slot "a")
              (slot "b")
            ];
        };
        settings = {
          keyring = {
            path = toString snakeOilRaucCert;
            use-bundle-signing-time = true;
            check-purpose = "codesign";
          };
          handlers = {
            system-info = toString (
              pkgs.writeShellScript "rauc-sysinfo.sh" ''
                echo "RAUC_SYSTEM_SERIAL=nixos"
                echo "RAUC_SYSTEM_VARIANT=nix/widget/smoketest"
              ''
            );
            bootloader-custom-backend = toString (
              pkgs.writeShellScript "rauc-backend.sh" ''
                case "$1" in
                  get-primary)
                    cat /rauc.current || exit $?
                    ;;
                  set-primary)
                    echo "$2" > /rauc.current
                    ;;
                  get-state)
                    cat "/rauc.$2.status" || echo bad
                    ;;
                  set-state)
                    echo "$3" > "/rauc.$2.status"
                    ;;
                  get-current)
                    cat /rauc.booted
                    ;;
                  *)
                    exit 1
                    ;;
                esac
              ''
            );
          };
        };
      };

      boot.initrd = {
        postDeviceCommands = ''
          ensure_ext4() {
            x="$(echo "$1" | tr ab bc)"
            if [ "$(blkid -t TYPE=ext4 -l -o device "/dev/vd$x")" != "/dev/vd$x" ]; then
              ${pkgs.e2fsprogs}/bin/mkfs.ext4 -v -L "rauc_$1" "/dev/vd$x" || exit $?
            fi
          }
          ensure_ext4 a
          ensure_ext4 b
        '';

        postMountCommands = ''
          # Keep track of the current RAUC partition and the booted one.
          if [ ! -f /mnt-root/rauc.current ]; then
            echo a > /mnt-root/rauc.current
          fi
          cat /mnt-root/rauc.current > /mnt-root/rauc.booted

          # Initialize test rauc partitions using a custom backend for the test.
          init_ab() {
            mkdir -p "/mnt-root/rauc_$1"
            umount "/mnt-root/rauc_$1"
            mount -t ext4 "/dev/vd$(echo "$1" | tr ab bc)" "/mnt-root/rauc_$1" || exit $?
            if [ -d "/mnt-root/rauc_$1" ] && [ ! -f "/mnt-root/rauc_$1/label" ]; then
              echo "$1" > "/mnt-root/rauc_$1/label"
            fi
            echo bad > "/mnt-root/rauc.$1.status"
            umount "/mnt-root/rauc_$1"
            rm -rf "/mnt-root/rauc_$1"
          }
          init_ab a
          init_ab b

          # Mount the RAUC boot directory.
          mkdir -p /mnt-root/rauc
          booted="/dev/vd$(tr ab bc < /mnt-root/rauc.booted)"
          echo "Mounting $booted to /rauc" | tee /dev/stderr
          mount "$booted" /mnt-root/rauc | tee /dev/stderr
        '';
      };

      virtualisation = {
        emptyDiskImages = [
          256
          256
        ];
      };
    };

  testScript =
    { nodes, ... }:
    ''
      from shlex import quote, join

      def rauc(*rauc_args):
        rauc_cmd = join(rauc_args)
        ret = machine.succeed(f'rauc {rauc_cmd} --output-format=json')
        machine.succeed('rauc status >&2')
        return ret

      def wait_rauc(result, *jq_args):
        jq_cmd = join([*jq_args[:-1], '-r', *jq_args[-1:]])
        machine.wait_until_succeeds(f'[ "$(rauc status --output-format=json | jq {jq_cmd})" == {quote(result)} ]')
        machine.succeed("rauc status >&2")

      def name(slot):
        return 'rauc.%d' % (int(slot, 16) - 10)

      def wait_booted(slot, image=None):
        if image is None:
          image = slot
        wait_rauc(slot, '.booted')
        machine.wait_until_succeeds(f'[ "$(</rauc/label)" == {quote(image)} ]')
      def wait_current(slot):
        wait_rauc(name(slot), '.boot_primary')
      def wait_status(slot, status):
        wait_rauc(status, '--arg', 'slot', slot, '.slots[] | to_entries[] | select(.value.bootname == $slot) | .value.boot_status')
      def wait_state(slot, state):
        wait_rauc(state, '--arg', 'slot', slot, '.slots[] | to_entries[] | select(.value.bootname == $slot) | .value.state')
      def set_slot(slot):
        rauc('status', 'mark-active', name(slot))
        wait_rauc(slot, '--arg', 'slot', slot, '.boot_primary as $primary | .slots[] | to_entries[] | select(.key == $primary) | .value.bootname')

      machine.start(allow_reboot=True)
      machine.wait_for_unit('multi-user.target')

      for (a, b, image, update) in (('a', 'b', 'a', ""), ('b', 'a', 'b', 'c'), ('a', 'b', 'c', "")):
        machine.wait_for_unit('rauc.service')
        machine.succeed("mount >&2")
        wait_booted(a, image)
        wait_current(a)
        wait_status(a, 'good')
        wait_status(b, 'bad')
        wait_state(a, 'booted')
        wait_state(b, 'inactive')
        set_slot(b)
        wait_current(b)
        set_slot(a)
        wait_current(a)
        set_slot(b)
        wait_current(b)

        if update != "":
          machine.succeed(f'rauc-do-update {quote(update)}')

        machine.reboot()
    '';
}
