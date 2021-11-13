{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; },
  debug ? false,
  enableUnfree ? false,
  # Nested KVM virtualization (https://www.linux-kvm.org/page/Nested_Guests)
  # requires a modprobe flag on the build machine: (kvm-amd for AMD CPUs)
  #   boot.extraModprobeConfig = "options kvm-intel nested=Y";
  # Without this VirtualBox will use SW virtualization and will only be able
  # to run 32-bit guests.
  useKvmNestedVirt ? false,
  # Whether to run 64-bit guests instead of 32-bit. Requires nested KVM.
  use64bitGuest ? false
}:

assert use64bitGuest -> useKvmNestedVirt;

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  testVMConfig = vmName: attrs: { config, pkgs, lib, ... }: let
    guestAdditions = pkgs.linuxPackages.virtualboxGuestAdditions;

    miniInit = ''
      #!${pkgs.runtimeShell} -xe
      export PATH="${lib.makeBinPath [ pkgs.coreutils pkgs.util-linux ]}"

      mkdir -p /run/dbus
      cat > /etc/passwd <<EOF
      root:x:0:0::/root:/bin/false
      messagebus:x:1:1::/run/dbus:/bin/false
      EOF
      cat > /etc/group <<EOF
      root:x:0:
      messagebus:x:1:
      EOF

      "${pkgs.dbus.daemon}/bin/dbus-daemon" --fork \
        --config-file="${pkgs.dbus.daemon}/share/dbus-1/system.conf"

      ${guestAdditions}/bin/VBoxService
      ${(attrs.vmScript or (const "")) pkgs}

      i=0
      while [ ! -e /mnt-root/shutdown ]; do
        sleep 10
        i=$(($i + 10))
        [ $i -le 120 ] || fail
      done

      rm -f /mnt-root/boot-done /mnt-root/shutdown
    '';
  in {
    boot.kernelParams = [
      "console=tty0" "console=ttyS0" "ignore_loglevel"
      "boot.trace" "panic=1" "boot.panic_on_fail"
      "init=${pkgs.writeScript "mini-init.sh" miniInit}"
    ];

    fileSystems."/" = {
      device = "vboxshare";
      fsType = "vboxsf";
    };

    virtualisation.virtualbox.guest.enable = true;

    boot.initrd.kernelModules = [
      "af_packet" "vboxsf"
      "virtio" "virtio_pci" "virtio_ring" "virtio_net" "vboxguest"
    ];

    boot.initrd.extraUtilsCommands = ''
      copy_bin_and_libs "${guestAdditions}/bin/mount.vboxsf"
      copy_bin_and_libs "${pkgs.util-linux}/bin/unshare"
      ${(attrs.extraUtilsCommands or (const "")) pkgs}
    '';

    boot.initrd.postMountCommands = ''
      touch /mnt-root/boot-done
      hostname "${vmName}"
      mkdir -p /nix/store
      unshare -m ${escapeShellArg pkgs.runtimeShell} -c '
        mount -t vboxsf nixstore /nix/store
        exec "$stage2Init"
      '
      poweroff -f
    '';

    system.requiredKernelConfig = with config.lib.kernelConfig; [
      (isYes "SERIAL_8250_CONSOLE")
      (isYes "SERIAL_8250")
    ];

    networking.usePredictableInterfaceNames = false;
  };

  mkLog = logfile: tag: let
    rotated = map (i: "${logfile}.${toString i}") (range 1 9);
    all = concatMapStringsSep " " (f: "\"${f}\"") ([logfile] ++ rotated);
    logcmd = "tail -F ${all} 2> /dev/null | logger -t \"${tag}\"";
  in if debug then "machine.execute(ru('${logcmd} & disown'))" else "pass";

  testVM = vmName: vmScript: let
    cfg = (import ../lib/eval-config.nix {
      system = if use64bitGuest then "x86_64-linux" else "i686-linux";
      modules = [
        ../modules/profiles/minimal.nix
        (testVMConfig vmName vmScript)
      ];
    }).config;
  in pkgs.vmTools.runInLinuxVM (pkgs.runCommand "virtualbox-image" {
    preVM = ''
      mkdir -p "$out"
      diskImage="$(pwd)/qimage"
      ${pkgs.vmTools.qemu}/bin/qemu-img create -f raw "$diskImage" 100M
    '';

    postVM = ''
      echo "creating VirtualBox disk image..."
      ${pkgs.vmTools.qemu}/bin/qemu-img convert -f raw -O vdi \
        "$diskImage" "$out/disk.vdi"
    '';

    buildInputs = [ pkgs.util-linux pkgs.perl ];
  } ''
    ${pkgs.parted}/sbin/parted --script /dev/vda mklabel msdos
    ${pkgs.parted}/sbin/parted --script /dev/vda -- mkpart primary ext2 1M -1s
    ${pkgs.e2fsprogs}/sbin/mkfs.ext4 /dev/vda1
    ${pkgs.e2fsprogs}/sbin/tune2fs -c 0 -i 0 /dev/vda1
    mkdir /mnt
    mount /dev/vda1 /mnt
    cp "${cfg.system.build.kernel}/bzImage" /mnt/linux
    cp "${cfg.system.build.initialRamdisk}/initrd" /mnt/initrd

    ${pkgs.grub2}/bin/grub-install --boot-directory=/mnt /dev/vda

    cat > /mnt/grub/grub.cfg <<GRUB
    set root=hd0,1
    linux /linux ${concatStringsSep " " cfg.boot.kernelParams}
    initrd /initrd
    boot
    GRUB
    umount /mnt
  '');

  createVM = name: attrs: let
    mkFlags = concatStringsSep " ";

    sharePath = "/home/alice/vboxshare-${name}";

    createFlags = mkFlags [
      "--ostype ${if use64bitGuest then "Linux26_64" else "Linux26"}"
      "--register"
    ];

    vmFlags = mkFlags ([
      "--uart1 0x3F8 4"
      "--uartmode1 client /run/virtualbox-log-${name}.sock"
      "--memory 768"
      "--audio none"
    ] ++ (attrs.vmFlags or []));

    controllerFlags = mkFlags [
      "--name SATA"
      "--add sata"
      "--bootable on"
      "--hostiocache on"
    ];

    diskFlags = mkFlags [
      "--storagectl SATA"
      "--port 0"
      "--device 0"
      "--type hdd"
      "--mtype immutable"
      "--medium ${testVM name attrs}/disk.vdi"
    ];

    sharedFlags = mkFlags [
      "--name vboxshare"
      "--hostpath ${sharePath}"
    ];

    nixstoreFlags = mkFlags [
      "--name nixstore"
      "--hostpath /nix/store"
      "--readonly"
    ];
  in {
    machine = {
      systemd.sockets."vboxtestlog-${name}" = {
        description = "VirtualBox Test Machine Log Socket For ${name}";
        wantedBy = [ "sockets.target" ];
        before = [ "multi-user.target" ];
        socketConfig.ListenStream = "/run/virtualbox-log-${name}.sock";
        socketConfig.Accept = true;
      };

      systemd.services."vboxtestlog-${name}@" = {
        description = "VirtualBox Test Machine Log For ${name}";
        serviceConfig.StandardInput = "socket";
        serviceConfig.SyslogIdentifier = "GUEST-${name}";
        serviceConfig.ExecStart = "${pkgs.coreutils}/bin/cat";
      };
    };

    testSubs = ''


      ${name}_sharepath = "${sharePath}"


      def check_running_${name}():
          cmd = "VBoxManage list runningvms | grep -q '^\"${name}\"'"
          (status, _) = machine.execute(ru(cmd))
          return status == 0


      def cleanup_${name}():
          if check_running_${name}():
              machine.execute(ru("VBoxManage controlvm ${name} poweroff"))
          machine.succeed("rm -rf ${sharePath}")
          machine.succeed("mkdir -p ${sharePath}")
          machine.succeed("chown alice.users ${sharePath}")


      def create_vm_${name}():
          vbm("createvm --name ${name} ${createFlags}")
          vbm("modifyvm ${name} ${vmFlags}")
          vbm("setextradata ${name} VBoxInternal/PDM/HaltOnReset 1")
          vbm("storagectl ${name} ${controllerFlags}")
          vbm("storageattach ${name} ${diskFlags}")
          vbm("sharedfolder add ${name} ${sharedFlags}")
          vbm("sharedfolder add ${name} ${nixstoreFlags}")
          cleanup_${name}()

          ${mkLog "$HOME/VirtualBox VMs/${name}/Logs/VBox.log" "HOST-${name}"}


      def destroy_vm_${name}():
          cleanup_${name}()
          vbm("unregistervm ${name} --delete")


      def wait_for_vm_boot_${name}():
          machine.execute(
              ru(
                  "set -e; i=0; "
                  "while ! test -e ${sharePath}/boot-done; do "
                  "sleep 10; i=$(($i + 10)); [ $i -le 3600 ]; "
                  "VBoxManage list runningvms | grep -q '^\"${name}\"'; "
                  "done"
              )
          )


      def wait_for_ip_${name}(interface):
          property = f"/VirtualBox/GuestInfo/Net/{interface}/V4/IP"
          getip = f"VBoxManage guestproperty get ${name} {property} | sed -n -e 's/^Value: //p'"

          ip = machine.succeed(
              ru(
                  "for i in $(seq 1000); do "
                  f'if ipaddr="$({getip})" && [ -n "$ipaddr" ]; then '
                  'echo "$ipaddr"; exit 0; '
                  "fi; "
                  "sleep 1; "
                  "done; "
                  "echo 'Could not get IPv4 address for ${name}!' >&2; "
                  "exit 1"
              )
          ).strip()
          return ip


      def wait_for_startup_${name}(nudge=lambda: None):
          for _ in range(0, 130, 10):
              machine.sleep(10)
              if check_running_${name}():
                  return
              nudge()
          raise Exception("VirtualBox VM didn't start up within 2 minutes")


      def wait_for_shutdown_${name}():
          for _ in range(0, 130, 10):
              machine.sleep(10)
              if not check_running_${name}():
                  return
          raise Exception("VirtualBox VM didn't shut down within 2 minutes")


      def shutdown_vm_${name}():
          machine.succeed(ru("touch ${sharePath}/shutdown"))
          machine.execute(
              "set -e; i=0; "
              "while test -e ${sharePath}/shutdown "
              "        -o -e ${sharePath}/boot-done; do "
              "sleep 1; i=$(($i + 1)); [ $i -le 3600 ]; "
              "done"
          )
          wait_for_shutdown_${name}()
    '';
  };

  hostonlyVMFlags = [
    "--nictype1 virtio"
    "--nictype2 virtio"
    "--nic2 hostonly"
    "--hostonlyadapter2 vboxnet0"
  ];

  # The VirtualBox Oracle Extension Pack lets you use USB 3.0 (xHCI).
  enableExtensionPackVMFlags = [
    "--usbxhci on"
  ];

  dhcpScript = pkgs: ''
    ${pkgs.dhcp}/bin/dhclient \
      -lf /run/dhcp.leases \
      -pf /run/dhclient.pid \
      -v eth0 eth1

    otherIP="$(${pkgs.netcat}/bin/nc -l 1234 || :)"
    ${pkgs.iputils}/bin/ping -I eth1 -c1 "$otherIP"
    echo "$otherIP reachable" | ${pkgs.netcat}/bin/nc -l 5678 || :
  '';

  sysdDetectVirt = pkgs: ''
    ${pkgs.systemd}/bin/systemd-detect-virt > /mnt-root/result
  '';

  vboxVMs = mapAttrs createVM {
    simple = {};

    detectvirt.vmScript = sysdDetectVirt;

    test1.vmFlags = hostonlyVMFlags;
    test1.vmScript = dhcpScript;

    test2.vmFlags = hostonlyVMFlags;
    test2.vmScript = dhcpScript;

    headless.virtualisation.virtualbox.headless = true;
    headless.services.xserver.enable = false;
  };

  vboxVMsWithExtpack = mapAttrs createVM {
    testExtensionPack.vmFlags = enableExtensionPackVMFlags;
  };

  mkVBoxTest = useExtensionPack: vms: name: testScript: makeTest {
    name = "virtualbox-${name}";

    machine = { lib, config, ... }: {
      imports = let
        mkVMConf = name: val: val.machine // { key = "${name}-config"; };
        vmConfigs = mapAttrsToList mkVMConf vms;
      in [ ./common/user-account.nix ./common/x11.nix ] ++ vmConfigs;
      virtualisation.memorySize = 2048;
      virtualisation.qemu.options =
        if useKvmNestedVirt then ["-cpu" "kvm64,vmx=on"] else [];
      virtualisation.virtualbox.host.enable = true;
      test-support.displayManager.auto.user = "alice";
      users.users.alice.extraGroups = let
        inherit (config.virtualisation.virtualbox.host) enableHardening;
      in lib.mkIf enableHardening (lib.singleton "vboxusers");
      virtualisation.virtualbox.host.enableExtensionPack = useExtensionPack;
      nixpkgs.config.allowUnfree = useExtensionPack;
    };

    testScript = ''
      from shlex import quote
      ${concatStrings (mapAttrsToList (_: getAttr "testSubs") vms)}

      def ru(cmd: str) -> str:
          return f"su - alice -c {quote(cmd)}"


      def vbm(cmd: str) -> str:
          return machine.succeed(ru(f"VBoxManage {cmd}"))


      def remove_uuids(output: str) -> str:
          return "\n".join(
              [line for line in (output or "").splitlines() if not line.startswith("UUID:")]
          )


      machine.wait_for_x()

      ${mkLog "$HOME/.config/VirtualBox/VBoxSVC.log" "HOST-SVC"}

      ${testScript}
      # (keep black happy)
    '';

    meta = with pkgs.lib.maintainers; {
      maintainers = [ aszlig cdepillabout ];
    };
  };

  unfreeTests = mapAttrs (mkVBoxTest true vboxVMsWithExtpack) {
    enable-extension-pack = ''
      create_vm_testExtensionPack()
      vbm("startvm testExtensionPack")
      wait_for_startup_testExtensionPack()
      machine.screenshot("cli_started")
      wait_for_vm_boot_testExtensionPack()
      machine.screenshot("cli_booted")

      with machine.nested("Checking for privilege escalation"):
          machine.fail("test -e '/root/VirtualBox VMs'")
          machine.fail("test -e '/root/.config/VirtualBox'")
          machine.succeed("test -e '/home/alice/VirtualBox VMs'")

      shutdown_vm_testExtensionPack()
      destroy_vm_testExtensionPack()
    '';
  };

in mapAttrs (mkVBoxTest false vboxVMs) {
  simple-gui = ''
    # Home to select Tools, down to move to the VM, enter to start it.
    def send_vm_startup():
        machine.send_key("home")
        machine.send_key("down")
        machine.send_key("ret")


    create_vm_simple()
    machine.succeed(ru("VirtualBox >&2 &"))
    machine.wait_until_succeeds(ru("xprop -name 'Oracle VM VirtualBox Manager'"))
    machine.sleep(5)
    machine.screenshot("gui_manager_started")
    send_vm_startup()
    machine.screenshot("gui_manager_sent_startup")
    wait_for_startup_simple(send_vm_startup)
    machine.screenshot("gui_started")
    wait_for_vm_boot_simple()
    machine.screenshot("gui_booted")
    shutdown_vm_simple()
    machine.sleep(5)
    machine.screenshot("gui_stopped")
    machine.send_key("ctrl-q")
    machine.sleep(5)
    machine.screenshot("gui_manager_stopped")
    destroy_vm_simple()
  '';

  simple-cli = ''
    create_vm_simple()
    vbm("startvm simple")
    wait_for_startup_simple()
    machine.screenshot("cli_started")
    wait_for_vm_boot_simple()
    machine.screenshot("cli_booted")

    with machine.nested("Checking for privilege escalation"):
        machine.fail("test -e '/root/VirtualBox VMs'")
        machine.fail("test -e '/root/.config/VirtualBox'")
        machine.succeed("test -e '/home/alice/VirtualBox VMs'")

    shutdown_vm_simple()
    destroy_vm_simple()
  '';

  headless = ''
    create_vm_headless()
    machine.succeed(ru("VBoxHeadless --startvm headless & disown %1"))
    wait_for_startup_headless()
    wait_for_vm_boot_headless()
    shutdown_vm_headless()
    destroy_vm_headless()
  '';

  host-usb-permissions = ''
    user_usb = remove_uuids(vbm("list usbhost"))
    print(user_usb, file=sys.stderr)
    root_usb = remove_uuids(machine.succeed("VBoxManage list usbhost"))
    print(root_usb, file=sys.stderr)

    if user_usb != root_usb:
        raise Exception("USB host devices differ for root and normal user")
    if "<none>" in user_usb:
        raise Exception("No USB host devices found")
  '';

  systemd-detect-virt = ''
    create_vm_detectvirt()
    vbm("startvm detectvirt")
    wait_for_startup_detectvirt()
    wait_for_vm_boot_detectvirt()
    shutdown_vm_detectvirt()
    result = machine.succeed(f"cat '{detectvirt_sharepath}/result'").strip()
    destroy_vm_detectvirt()
    if result != "oracle":
        raise Exception(f'systemd-detect-virt returned "{result}" instead of "oracle"')
  '';

  net-hostonlyif = ''
    create_vm_test1()
    create_vm_test2()

    vbm("startvm test1")
    wait_for_startup_test1()
    wait_for_vm_boot_test1()

    vbm("startvm test2")
    wait_for_startup_test2()
    wait_for_vm_boot_test2()

    machine.screenshot("net_booted")

    test1_ip = wait_for_ip_test1(1)
    test2_ip = wait_for_ip_test2(1)

    machine.succeed(f"echo '{test2_ip}' | nc -N '{test1_ip}' 1234")
    machine.succeed(f"echo '{test1_ip}' | nc -N '{test2_ip}' 1234")

    machine.wait_until_succeeds(f"nc -N '{test1_ip}' 5678 < /dev/null >&2")
    machine.wait_until_succeeds(f"nc -N '{test2_ip}' 5678 < /dev/null >&2")

    shutdown_vm_test1()
    shutdown_vm_test2()

    destroy_vm_test1()
    destroy_vm_test2()
  '';
} // (if enableUnfree then unfreeTests else {})
