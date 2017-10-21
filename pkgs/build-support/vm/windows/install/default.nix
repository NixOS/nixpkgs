{ stdenv, runCommand, openssh, qemu, controller, mkCygwinImage
, writeText, dosfstools, mtools
}:

{ isoFile
, productKey
}:

let
  bootstrapAfterLogin = runCommand "bootstrap.sh" {} ''
    cat > "$out" <<EOF
    mkdir -p ~/.ssh
    cat > ~/.ssh/authorized_keys <<PUBKEY
    $(cat "${cygwinSshKey}/key.pub")
    PUBKEY
    ssh-host-config -y -c 'binmode ntsec' -w dummy
    cygrunsrv -S sshd
    shutdown -s 5
    EOF
  '';

  cygwinSshKey = stdenv.mkDerivation {
    name = "snakeoil-ssh-cygwin";
    buildCommand = ''
      mkdir -p "$out"
      ${openssh}/bin/ssh-keygen -t ecdsa -f "$out/key" -N ""
    '';
  };

  sshKey = "${cygwinSshKey}/key";

  packages = [ "openssh" "shutdown" ];

  floppyCreator = import ./unattended-image.nix {
    inherit stdenv writeText dosfstools mtools;
  };

  instfloppy = floppyCreator {
    cygwinPackages = packages;
    inherit productKey;
  };

  cygiso = mkCygwinImage {
    inherit packages;
    extraContents = stdenv.lib.singleton {
      source = bootstrapAfterLogin;
      target = "bootstrap.sh";
    };
  };

  installController = controller {
    inherit sshKey;
    installMode = true;
    qemuArgs = [
      "-boot order=c,once=d"
      "-drive file=${instfloppy},readonly,index=0,if=floppy"
      "-drive file=winvm.img,index=0,media=disk"
      "-drive file=${isoFile},index=1,media=cdrom"
      "-drive file=${cygiso}/iso/cd.iso,index=2,media=cdrom"
    ];
  };

in stdenv.mkDerivation {
  name = "cygwin-base-vm";
  buildCommand = ''
    ${qemu}/bin/qemu-img create -f qcow2 winvm.img 2G
    ${installController}
    mkdir -p "$out"
    cp winvm.img "$out/disk.img"
  '';
  passthru = {
    inherit sshKey;
  };
}
