import ./make-test-python.nix ({ pkgs, ... }: {
  name = "mtp";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ matthewcroughan nixinator ];
  };

  nodes =
  {
    client = { config, pkgs, ... }: {
      # DBUS runs only once a user session is created, which means a user has to
      # login. Here, we log in as root. Once logged in, the gvfs-daemon service runs
      # as UID 0 in User-0.service
      services.getty.autologinUser = "root";

      # XDG_RUNTIME_DIR is needed for running systemd-user services such as
      # gvfs-daemon as root.
      environment.variables.XDG_RUNTIME_DIR = "/run/user/0";

      environment.systemPackages = with pkgs; [ usbutils glib jmtpfs tree ];
      services.gvfs.enable = true;

      # Creates a usb-mtp device inside the VM, which is mapped to the host's
      # /tmp folder, it is able to write files to this location, but only has
      # permissions to read its own creations.
      virtualisation.qemu.options = [
        "-usb"
        "-device usb-mtp,rootdir=/tmp,readonly=false"
      ];
    };
  };


  testScript = { nodes, ... }:
    let
      # Creates a list of QEMU MTP devices matching USB ID (46f4:0004). This
      # value can be sourced in a shell script. This is so we can loop over the
      # devices we find, as this test may want to use more than one MTP device
      # in future.
      mtpDevices = pkgs.writeScript "mtpDevices.sh" ''
        export mtpDevices=$(lsusb -d 46f4:0004 | awk {'print $2","$4'} | sed 's/[:-]/ /g')
      '';
      # Qemu is only capable of creating an MTP device with Picture Transfer
      # Protocol. This means that gvfs must use gphoto2:// rather than mtp://
      # when mounting.
      # https://github.com/qemu/qemu/blob/970bc16f60937bcfd334f14c614bd4407c247961/hw/usb/dev-mtp.c#L278
      gvfs = rec {
        mountAllMtpDevices = pkgs.writeScript "mountAllMtpDevices.sh" ''
          set -e
          source ${mtpDevices}
          for i in $mtpDevices
          do
            gio mount "gphoto2://[usb:$i]/"
          done
        '';
        unmountAllMtpDevices = pkgs.writeScript "unmountAllMtpDevices.sh" ''
          set -e
          source ${mtpDevices}
          for i in $mtpDevices
          do
            gio mount -u "gphoto2://[usb:$i]/"
          done
        '';
        # gvfsTest:
        # 1. Creates a 10M test file
        # 2. Copies it to the device using GIO tools
        # 3. Checks for corruption with `diff`
        # 4. Removes the file, then unmounts the disks.
        gvfsTest = pkgs.writeScript "gvfsTest.sh" ''
          set -e
          source ${mtpDevices}
          ${mountAllMtpDevices}
          dd if=/dev/urandom of=testFile10M bs=1M count=10
          for i in $mtpDevices
          do
            gio copy ./testFile10M gphoto2://[usb:$i]/
            ls -lah /run/user/0/gvfs/*/testFile10M
            gio remove gphoto2://[usb:$i]/testFile10M
          done
          ${unmountAllMtpDevices}
        '';
      };
      jmtpfs = {
        # jmtpfsTest:
        # 1. Mounts the device on a dir named `phone` using jmtpfs
        # 2. Puts the current Nixpkgs libmtp version into a file
        # 3. Checks for corruption with `diff`
        # 4. Prints the directory tree
        jmtpfsTest = pkgs.writeScript "jmtpfsTest.sh" ''
          set -e
          mkdir phone
          jmtpfs phone
          echo "${pkgs.libmtp.version}" > phone/tmp/testFile
          echo "${pkgs.libmtp.version}" > testFile
          diff phone/tmp/testFile testFile
          tree phone
        '';
      };
    in
    # Using >&2 allows the results of the scripts to be printed to the terminal
    # when building this test with Nix. Scripts would otherwise complete
    # silently.
    ''
    start_all()
    client.wait_for_unit("multi-user.target")
    client.wait_for_unit("dbus.service")
    client.succeed("${gvfs.gvfsTest} >&2")
    client.succeed("${jmtpfs.jmtpfsTest} >&2")
  '';
})
