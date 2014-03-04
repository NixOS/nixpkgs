{ stdenv, fetchurl, vmTools, writeScript, writeText, runCommand, makeInitrd
, python, perl, coreutils, dosfstools, gzip, mtools, netcat, openssh, qemu
, samba, socat, vde2, cdrkit, pathsFromGraph
}:

{ isoFile, productKey, arch ? null }:

with stdenv.lib;

let
  controller = import ./controller {
    inherit stdenv writeScript vmTools makeInitrd;
    inherit samba vde2 openssh socat netcat coreutils gzip;
  };

  mkCygwinImage = import ./cygwin-iso {
    inherit stdenv fetchurl runCommand python perl cdrkit pathsFromGraph;
    arch = let
      defaultArch = if stdenv.is64bit then "x86_64" else "i686";
    in if arch == null then defaultArch else arch;
  };

  installer = import ./install {
    inherit controller mkCygwinImage;
    inherit stdenv runCommand openssh qemu writeText dosfstools mtools;
  };
in rec {
  installedVM = installer {
    inherit isoFile productKey;
  };

  runInVM = img: attrs: controller (attrs // {
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
    command = concatStringsSep " && " ([
      "net config server /autodisconnect:-1"
    ] ++ concatLists (mapAttrsToList genDriveCmds drives));
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
    qemuArgs = singleton "-snapshot";
    inherit command;
  };
}
