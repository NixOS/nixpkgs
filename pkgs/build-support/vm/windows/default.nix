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

  builder = ''
    source /tmp/xchg/saved-env 2> /dev/null || true
    export NIX_STORE=/nix/store
    export NIX_BUILD_TOP=/tmp
    export TMPDIR=/tmp
    export PATH=/empty
    cd "$NIX_BUILD_TOP"
    exec $origBuilder $origArgs
  '';

in {
  runInWindowsVM = drv: let
    newDrv = drv.override {
      stdenv = drv.stdenv.override {
        shell = "/bin/sh";
      };
    };
  in lib.overrideDerivation drv (attrs: {
    requiredSystemFeatures = [ "kvm" ];
    buildur = "${stdenv.shell}";
    args = ["-e" (resumeAndRun builder)];
    origArgs = attrs.args;
    origBuilder = if attrs.builder == attrs.stdenv.shell
                  then "/bin/sh"
                  else attrs.builder;

    postHook = ''
      PATH=/usr/bin:/bin:/usr/sbin:/sbin
      SHELL=/bin/sh
      eval "$origPostHook"
    '';

    origPostHook = attrs.postHook or "";
    fixupPhase = ":";
  });
}
