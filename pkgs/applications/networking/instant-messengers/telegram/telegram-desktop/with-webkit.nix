{
  stdenv,
  lib,
  telegram-desktop,
  makeBinaryWrapper,
  wrapGAppsHook3,
  glib-networking,
  webkitgtk_4_1,
}:

if stdenv.hostPlatform.isLinux then
  stdenv.mkDerivation {
    pname = "${telegram-desktop.pname}-with-webkit";
    version = telegram-desktop.version;
    nativeBuildInputs = telegram-desktop.nativeBuildInputs ++ [
      makeBinaryWrapper
      wrapGAppsHook3
    ];
    buildInputs = telegram-desktop.buildInputs ++ [
      glib-networking
      webkitgtk_4_1
    ];
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    dontWrapGApps = true;
    dontWrapQtApps = true;
    installPhase = ''
      mkdir -p $out
      cp -r ${telegram-desktop}/share $out
      substituteInPlace $out/share/dbus-1/services/* --replace-fail ${telegram-desktop} $out
    '';
    postFixup = ''
      mkdir -p $out/bin
      makeBinaryWrapper ${telegram-desktop}/bin/.${telegram-desktop.meta.mainProgram}-wrapped $out/bin/${telegram-desktop.meta.mainProgram} \
        --inherit-argv0 \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ webkitgtk_4_1 ]} \
        ''${qtWrapperArgs[@]} \
        ''${gappsWrapperArgs[@]}
    '';
    passthru = telegram-desktop.passthru;
    meta = telegram-desktop.meta // {
      platforms = lib.platforms.linux;
    };
  }
else
  telegram-desktop
