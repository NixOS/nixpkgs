{ lib, stdenv, writeScript, callPackage, buildFHSEnv, unwrapped ? callPackage ./runtime.nix {} }:

buildFHSEnv rec {
  name = "houdini-${unwrapped.version}";

  targetPkgs = pkgs: with pkgs; [
    libGLU
    libGL
    alsa-lib
    fontconfig
    zlib
    libpng
    dbus
    nss
    nspr
    expat
    pciutils
    libxkbcommon
    libudev0-shim
    tbb
    xwayland
    qt5.qtwayland
    nettools  # needed by licensing tools
    bintools  # needed for ld and other tools, so ctypes can find/load sos from python
    ocl-icd  # needed for opencl
    numactl  # needed by hfs ocl backend
    ncurses5  # needed by hfs ocl backend
  ] ++ (with xorg; [
    libICE
    libSM
    libXmu
    libXi
    libXt
    libXext
    libX11
    libXrender
    libXcursor
    libXfixes
    libXrender
    libXcomposite
    libXdamage
    libXtst
    libxcb
    libXScrnSaver
    libXrandr
    libxcb
    xcbutil
    xcbutilimage
    xcbutilrenderutil
    xcbutilcursor
    xcbutilkeysyms
    xcbutilwm
  ]);

  passthru = {
    inherit unwrapped;
  };

  extraInstallCommands = let
    executables = [
      "bin/houdini"
      "bin/hkey"
      "houdini/sbin/sesinetd"
    ];
  in ''
    WRAPPER=$out/bin/${name}
    EXECUTABLES="${lib.concatStringsSep " " executables}"
    for executable in $EXECUTABLES; do
      mkdir -p $out/$(dirname $executable)

      echo "#!${stdenv.shell}" >> $out/$executable
      echo "$WRAPPER ${unwrapped}/$executable \$@" >> $out/$executable
    done

    cd $out
    chmod +x $EXECUTABLES
  '';

  runScript = writeScript "${name}-wrapper" ''
    exec $@
  '';
}
