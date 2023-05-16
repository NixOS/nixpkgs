{ lib
, buildFHSEnv
, sparrow-unwrapped
}:

buildFHSEnv {
<<<<<<< HEAD
  name = "sparrow-desktop";

  runScript = "${sparrow-unwrapped}/bin/sparrow-desktop";
=======
  name = "sparrow";

  runScript = "${sparrow-unwrapped}/bin/sparrow";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  targetPkgs = pkgs: with pkgs; [
    sparrow-unwrapped
    pcsclite
  ];

  multiPkgs = pkgs: with pkgs; [
    pcsclite
  ];

  extraInstallCommands = ''
    mkdir -p $out/share
    ln -s ${sparrow-unwrapped}/share/applications $out/share
    ln -s ${sparrow-unwrapped}/share/icons $out/share

    mkdir -p $out/etc/udev
    ln -s ${sparrow-unwrapped}/etc/udev/rules.d $out/etc/udev/rules.d
  '';

  meta = sparrow-unwrapped.meta;
}
