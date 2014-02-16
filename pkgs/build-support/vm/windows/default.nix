let
  inherit (import <nixpkgs> {}) lib stdenv requireFile writeText qemu;

  winISO = /path/to/iso/XXX;

  installedVM = import ./install {
    isoFile = winISO;
    productKey = "XXX";
  };

  runInVM = img: attrs: import ./controller (attrs // {
    inherit (installedVM) sshKey;
    qemuArgs = attrs.qemuArgs or [] ++ [
      "-boot order=c"
      "-drive file=${img},index=0,media=disk"
    ];
  });

  runAndSuspend = runInVM "winvm.img" {
    command = lib.concatStringsSep " && " [
      "net config server /autodisconnect:-1"
      "net use S: '\\\\192.168.0.2\\nixstore' /persistent:yes"
      "net use X: '\\\\192.168.0.2\\xchg' /persistent:yes"
      "mkdir -p /nix/store"
      "mount -o bind /cygdrive/s /nix/store"
      "echo /cygdrive/s /nix/store none bind 0 0 >> /etc/fstab"
      "mkdir -p /tmp/xchg"
      "mount -o bind /cygdrive/x /tmp/xchg"
      "echo /cygdrive/x /tmp/xchg none bind 0 0 >> /etc/fstab"
    ];
    suspendTo = "state.gz";
  };

  suspendedVM = stdenv.mkDerivation {
    name = "cygwin-suspended-vm";
    buildCommand = ''
      ${qemu}/bin/qemu-img create \
        -b "${installedVM}/disk.img" \
        -f qcow2 winvm.img
      ${runAndSuspend}
      ensureDir "$out"
      cp winvm.img "$out/disk.img"
      cp state.gz "$out/state.gz"
    '';
  };

  resumeAndRun = command: runInVM "${suspendedVM}/disk.img" {
    resumeFrom = "${suspendedVM}/state.gz";
    qemuArgs = lib.singleton "-snapshot";
    inherit command;
  };

  runFromSuspended = command: stdenv.mkDerivation {
    name = "cygwin-vm-run";
    buildCommand = ''
      ${resumeAndRun command}
    '';
  };

in runFromSuspended "uname -a"
