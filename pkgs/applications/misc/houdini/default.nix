{ lib, stdenv, writeScript, callPackage, buildFHSEnv, unwrapped ? callPackage ./runtime.nix {} }:

buildFHSEnv rec {
  name = "houdini-${unwrapped.version}";

  targetPkgs = pkgs: with pkgs; [
    libGLU libGL alsa-lib fontconfig zlib libpng dbus nss nspr expat pciutils
    libxkbcommon libudev0-shim tbb
  ] ++ (with xorg; [
    libICE libSM libXmu libXi libXext libX11 libXrender libXcursor libXfixes
    libXrender libXcomposite libXdamage libXtst libxcb libXScrnSaver
  ]);

  passthru = {
    inherit unwrapped;
  };

  extraInstallCommands = let
    executables = [ "bin/houdini" "bin/hkey" "houdini/sbin/sesinetd" ];
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
