{
  symlinkJoin,
  buildFHSEnv,
  nitrolaunch-gui-unwrapped,
  nitrolaunch-cli-unwrapped,
  extraPkgs ? pkgs: [ ],
}:
let
  fhsEnv = {
    inherit (nitrolaunch-gui-unwrapped) version;
    targetPkgs =
      pkgs:
      with pkgs;
      [
        nitrolaunch-gui-unwrapped
        nitrolaunch-cli-unwrapped
        openal
        glfw3-minecraft
        alsa-lib
        libjack2
        libpulseaudio
        pipewire
        libGL
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXrandr
        xorg.libXxf86vm
        udev
        vulkan-loader
      ]
      ++ extraPkgs pkgs;
  };
in
symlinkJoin {
  name = "nitrolaunch";
  paths = [
    (buildFHSEnv (
      fhsEnv
      // {
        pname = "Nitrolaunch";
        runScript = "Nitrolaunch";
      }
    ))
    (buildFHSEnv (
      fhsEnv
      // {
        pname = "nitro";
        runScript = "nitro";
      }
    ))
  ];
  postBuild = ''
    mkdir -p $out/share
    ln -s ${nitrolaunch-gui-unwrapped}/share/applications $out/share
    ln -s ${nitrolaunch-gui-unwrapped}/share/icons $out/share
  '';

  inherit (nitrolaunch-gui-unwrapped) meta;
}
