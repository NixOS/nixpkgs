{ lib, stdenv, writeScript, callPackage, buildFHSEnv, unwrapped ? callPackage ./runtime.nix {} }:

buildFHSEnv rec {
  name = "houdini-${unwrapped.version}";

  # houdini spawns hserver (and other license tools) that is supposed to live beyond the lifespan of houdini process
  dieWithParent = false;

  # houdini needs to communicate with hserver process that it seem to be checking to be present in running processes
  unsharePid = false;

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
      "bin/houdini"  # houdini flavours
      "bin/houdinicore"
      "bin/houdinifx"
      "bin/hgpuinfo"  # houdini ocl config tool
      "bin/hotl"  # hda/otl manipulation tool
      "bin/hython"  # hython
      "bin/hkey"  # license administration
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

  extraBwrapArgs = [
    "--ro-bind-try /run/opengl-driver/etc/OpenCL/vendors /etc/OpenCL/vendors"  # this is the case of NixOS
    "--ro-bind-try /etc/OpenCL/vendors /etc/OpenCL/vendors"  # this is the case of not NixOS
  ];

  runScript = writeScript "${name}-wrapper" ''
    exec $@
  '';
}
