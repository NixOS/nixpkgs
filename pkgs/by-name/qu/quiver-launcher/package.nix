{
  lib,
  stdenv,
  steam,
  quiver-launcher-unwrapped,
  extraPkgs ? pkgs: [ ],
  extraLibraries ? pkgs: [ ],
  extraProfile ? "",
  extraEnv ? { },
}:

# steam.buildRuntimeEnv needs the i686 package set
if stdenv.hostPlatform.system != "x86_64-linux" then
  quiver-launcher-unwrapped
else
  steam.buildRuntimeEnv {
    pname = "quiver-launcher";
    inherit (quiver-launcher-unwrapped) version meta;

    inherit extraPkgs;
    # Quiver runs Proton outside the Steam runtime
    extraLibraries =
      pkgs:
      with pkgs;
      [
        alsa-lib
        fontconfig
        freetype
        libgcrypt
        libpulseaudio
        libusb1
        libxcomposite
        libxcursor
        libxi
        libxinerama
        libxrandr
        libxrender
        libxxf86vm
        pipewire
        SDL2
      ]
      ++ extraLibraries pkgs;
    inherit extraProfile extraEnv;

    executableName = quiver-launcher-unwrapped.meta.mainProgram;
    runScript = lib.getExe quiver-launcher-unwrapped;

    extraInstallCommands = ''
      ln -s ${quiver-launcher-unwrapped}/share $out/share
    '';

    privateTmp = false;
  }
