{
  lib,
  stdenv,
  symlinkJoin,
  modrinth-app-unwrapped,
  addDriverRunpath,
  flite,
  glib-networking,
  jdk8,
  jdk17,
  jdk21,
  jdks ? [
    jdk8
    jdk17
    jdk21
  ],
  libGL,
  libpulseaudio,
  udev,
  wrapGAppsHook3,
  xorg,
}:

symlinkJoin rec {
  name = "${pname}-${version}";
  pname = "modrinth-app";
  inherit (modrinth-app-unwrapped) version;

  paths = [ modrinth-app-unwrapped ];

  nativeBuildInputs = [ wrapGAppsHook3 ];

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
      stdenv.cc.cc.lib

      # narrator support
      flite

      # openal
      libpulseaudio

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
