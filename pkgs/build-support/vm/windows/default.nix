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
