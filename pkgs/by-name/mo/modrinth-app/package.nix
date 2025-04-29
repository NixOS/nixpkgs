{
  lib,
  stdenv,
  addDriverRunpath,
  alsa-lib,
  flite,
  glib-networking,
  jdk17,
  jdk21,
  jdk8,
  jdks ? [
    jdk8
    jdk17
    jdk21
  ],
  libGL,
  libjack2,
  libpulseaudio,
  modrinth-app-unwrapped,
  pipewire,
  symlinkJoin,
  udev,
  wrapGAppsHook4,
  xorg,
}:

symlinkJoin {
  pname = "modrinth-app";
  inherit (modrinth-app-unwrapped) version;

  paths = [ modrinth-app-unwrapped ];

  nativeBuildInputs = [ wrapGAppsHook4 ];

  buildInputs = [ glib-networking ];

  runtimeDependencies = lib.optionalString stdenv.hostPlatform.isLinux (
    lib.makeLibraryPath [
      addDriverRunpath.driverLink

      # glfw
      libGL
      xorg.libX11
      xorg.libXcursor
      xorg.libXext
      xorg.libXrandr
      xorg.libXxf86vm

      # lwjgl
      (lib.getLib stdenv.cc.cc)

      # narrator support
      flite

      # openal
      alsa-lib
      libjack2
      libpulseaudio
      pipewire

      # oshi
      udev
    ]
  );

  postBuild = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeSearchPath "bin/java" jdks}
      ${lib.optionalString stdenv.hostPlatform.isLinux ''
        --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]}
        --set LD_LIBRARY_PATH $runtimeDependencies
      ''}
    )

    wrapGAppsHook
  '';

  meta = {
    inherit (modrinth-app-unwrapped.meta)
      description
      longDescription
      homepage
      license
      maintainers
      mainProgram
      platforms
      broken
      ;
  };
}
