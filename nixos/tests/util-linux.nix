{ pkgs, lib, ... }:

{
  name = "util-linux";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ balsoft ];
  };

  nodes.machine =
    { ... }:
    let
      util-linux-with-check = pkgs.util-linux.overrideAttrs (_: {
        nativeCheckInputs = [
          pkgs.procps
          pkgs.iproute2
          pkgs.e2fsprogs
          pkgs.btrfs-progs
          pkgs.systemd
          pkgs.bc
        ];
        preCheck = ''
          patchShebangs tests
          make check-programs
        '';
        checkPhase = ''
          runHook preCheck
          # Disable some tests related to `mount`;
          # They all fail with
          #   /build/util-linux-2.41.2/mount: line 117: /build/util-linux-2.41.2/.libs/lt-mount: Permission denied
          # There is no .libs/lt-mount file, as far as I can tell, so this is a bit weird.
          exclude=(
            cramfs/doubles
            cramfs/mkfs
            fsck/ismounted
            libmount/loop
            libmount/loop-overlay
            misc/enosys
            mount/devname
            mount/fallback
            mount/fslists
            mount/fstab-bind
            mount/fstab-broken
            mount/fstab-btrfs
            mount/fstab-devname
            mount/fstab-devname2label
            mount/fstab-devname2uuid
            mount/fstab-label
            mount/fstab-label2devname
            mount/fstab-label2uuid
            mount/fstab-loop
            mount/fstab-none
            mount/fstab-symlink
            mount/fstab-uuid
            mount/fstab-uuid2devname
            mount/fstab-uuid2label
            mount/label
            mount/move
            mount/regfile
            mount/remount
            mount/set_ugid_mode
            mount/shared-subtree
            mount/special
            mount/subdir
            mount/uuid
            mount/xnocanon
            schedutils/chrt
          )
          ./tests/run.sh \
            --show-diff \
            --exclude="''${exclude[*]}"
          runHook postCheck
        '';
        doCheck = true;

        # Save some resources by not installing
        dontInstall = true;
        dontFixup = true;
      });
    in
    {
      networking.useDHCP = false;

      networking.interfaces = lib.mkForce { };

      environment.systemPackages = [
        (pkgs.writeShellScriptBin "util-linux-test" ''
          source ${util-linux-with-check.inputDerivation}
          ${lib.getExe' pkgs.coreutils "mkdir"} -p "$NIX_BUILD_TOP"
          cd "$PWD"
          # Run the derivation build
          exec "$_derivation_original_builder" $_derivation_original_args
        '')
      ];

      virtualisation.memorySize = 4096;
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")

    machine.succeed("systemd-cat -t TEST -p notice util-linux-test")
  '';
}
