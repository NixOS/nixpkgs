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
 libX11
 libXcursor
 libXext
 libXrandr
 libXxf86vm
 dev
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
