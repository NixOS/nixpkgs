pkgs:

let
  bootstrapper = import ./bootstrap.nix {
    inherit (pkgs) stdenv vmTools writeScript writeText runCommand makeInitrd;
    inherit (pkgs) coreutils dosfstools gzip mtools netcat openssh qemu samba;
    inherit (pkgs) socat vde2 fetchurl python perl cdrkit pathsFromGraph;
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
  in pkgs.lib.overrideDerivation drv (attrs: let
    bootstrap = bootstrapper attrs.windowsImage;
  in {
    requiredSystemFeatures = [ "kvm" ];
    builder = "${pkgs.stdenv.shell}";
    args = ["-e" (bootstrap.resumeAndRun builder)];
    windowsImage = bootstrap.suspendedVM;
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
