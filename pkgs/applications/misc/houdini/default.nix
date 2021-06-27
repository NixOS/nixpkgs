{ callPackage, buildFHSUserEnv, undaemonize, unwrapped ? callPackage ./runtime.nix {} }:

buildFHSUserEnv {
  name = "houdini-${unwrapped.version}";

  targetPkgs = pkgs: with pkgs; [
    libGLU libGL alsa-lib fontconfig zlib libpng dbus nss nspr expat pciutils libxkbcommon
  ] ++ (with xorg; [
    libICE libSM libXmu libXi libXext libX11 libXrender libXcursor libXfixes
    libXrender libXcomposite libXdamage libXtst libxcb libXScrnSaver
  ]);

  passthru = {
    inherit unwrapped;
  };

  runScript = "${undaemonize}/bin/undaemonize ${unwrapped}/bin/houdini";
}
