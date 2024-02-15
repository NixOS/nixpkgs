{
  lib,
  stdenv,
  symlinkJoin,
  modrinth-app-unwrapped,
  wrapGAppsHook,
  addOpenGLRunpath,
  flite,
  glib,
  glib-networking,
  jdk8,
  jdk17,
  jdks ? [
    jdk8
    jdk17
  ],
  libGL,
  libpulseaudio,
  udev,
  xorg,
}:
symlinkJoin rec {
  name = "${pname}-${version}";
  pname = "modrinth-app";
  inherit (modrinth-app-unwrapped) version;

  paths = [ modrinth-app-unwrapped ];

  buildInputs = [
    glib
    glib-networking
  ];

  nativeBuildInputs = [ wrapGAppsHook ];

  postBuild =
    let
      runtimeDependencies = [
        addOpenGLRunpath.driverLink
        flite # narrator support

        udev # oshi

        # lwjgl
        libGL
        libpulseaudio
        stdenv.cc.cc.lib
        xorg.libX11
        xorg.libXcursor
        xorg.libXext
        xorg.libXxf86vm
        xorg.libXrandr
      ];
    in
    ''
      gappsWrapperArgs+=(
        --prefix PATH : ${lib.makeSearchPath "bin/java" jdks}
        ${lib.optionalString stdenv.isLinux ''
          --set LD_LIBRARY_PATH ${lib.makeLibraryPath runtimeDependencies}
          --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]}
        ''}
      )

      wrapGAppsHook
    '';

  inherit (modrinth-app-unwrapped) meta;
}
