{
  lib,
  stdenv,
  symlinkJoin,
  modrinth-app-unwrapped,
  wrapGAppsHook3,
  addOpenGLRunpath,
  flite,
  glib,
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

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  runtimeDependencies = lib.optionalString stdenv.isLinux (
    lib.makeLibraryPath [
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
    ]
  );

  postBuild = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${lib.makeSearchPath "bin/java" jdks}
      ${lib.optionalString stdenv.isLinux ''
        --prefix PATH : ${lib.makeBinPath [ xorg.xrandr ]}
        --set LD_LIBRARY_PATH $runtimeDependencies
      ''}
    )

    wrapGAppsHook
  '';

  inherit (modrinth-app-unwrapped) meta;
}
