{
  lib,
  stdenv,
  addDriverRunpath,
  alsa-lib,
  flite,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  jdk25,
  jdk17,
  jdk21,
  jdk8,
  jdks ? [
    jdk8
    jdk17
    jdk21
    jdk25
  ],
  libGL,
  libjack2,
  libpulseaudio,
  modrinth-app-unwrapped,
  pipewire,
  symlinkJoin,
  udev,
  wrapGAppsHook3,
  libxxf86vm,
  libxrandr,
  libxext,
  libxcursor,
  libx11,
  xrandr,
}:

symlinkJoin {
  pname = "modrinth-app";
  inherit (modrinth-app-unwrapped) version;

  paths = [ modrinth-app-unwrapped ];

  strictDeps = true;

  nativeBuildInputs = [
    glib
    wrapGAppsHook3
  ];

  buildInputs = [
    glib-networking
    gsettings-desktop-schemas
  ];

  runtimeDependencies = lib.optionalString stdenv.hostPlatform.isLinux (
    lib.makeLibraryPath [
      addDriverRunpath.driverLink

      # glfw
      libGL
      libx11
      libxcursor
      libxext
      libxrandr
      libxxf86vm

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
        --prefix PATH : ${lib.makeBinPath [ xrandr ]}
        --set LD_LIBRARY_PATH $runtimeDependencies
      ''}
    )

    glibPostInstallHook
    gappsWrapperArgsHook
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
