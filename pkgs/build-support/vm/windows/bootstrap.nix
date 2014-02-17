{ isoFile, productKey }:

let
  inherit (import <nixpkgs> {}) lib stdenv qemu;
in rec {
  installedVM = import ./install {
    inherit isoFile productKey;
  };

  runInVM = img: attrs: import ./controller (attrs // {
    inherit (installedVM) sshKey;
    qemuArgs = attrs.qemuArgs or [] ++ [
      "-boot order=c"
      "-drive file=${img},index=0,media=disk"
    ];
  });

  runAndSuspend = let
    drives = {
      s = {
        source = "nixstore";
        target = "/nix/store";
      };
      x = {
        source = "xchg";
        target = "/tmp/xchg";
      };
    };

    genDriveCmds = letter: { source, target }: [
      "net use ${letter}: '\\\\192.168.0.2\\${source}' /persistent:yes"
      "mkdir -p '${target}'"
      "mount -o bind '/cygdrive/${letter}' '${target}'"
      "echo '/cygdrive/${letter} ${target} none bind 0 0' >> /etc/fstab"
    ];
  in runInVM "winvm.img" {
    command = lib.concatStringsSep " && " ([
      "net config server /autodisconnect:-1"
    ] ++ lib.concatLists (lib.mapAttrsToList genDriveCmds drives));
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
}
