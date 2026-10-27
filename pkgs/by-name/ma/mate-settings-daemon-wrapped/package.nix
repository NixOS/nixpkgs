{
  stdenv,
  mate-control-center,
  mate-settings-daemon,
  glib,
  wrapGAppsHook3,
}:

stdenv.mkDerivation {
  pname = "${mate-settings-daemon.pname}-wrapped";
  inherit (mate-settings-daemon) version outputs;

  nativeBuildInputs = [
    wrapGAppsHook3
  ];

  buildInputs = [
    glib
    mate-control-center
  ];

  dontWrapGApps = true;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/etc/xdg/autostart
    cp ${mate-settings-daemon}/etc/xdg/autostart/mate-settings-daemon.desktop $out/etc/xdg/autostart

    mkdir -p $out/share/man
    cp -r ${mate-settings-daemon.man}/share/man/* $out/share/man/
  '';

  postFixup = ''
    mkdir -p $out/libexec
    makeWrapper ${mate-settings-daemon}/libexec/mate-settings-daemon $out/libexec/mate-settings-daemon \
      "''${gappsWrapperArgs[@]}"
    substituteInPlace $out/etc/xdg/autostart/mate-settings-daemon.desktop \
      --replace-fail "${mate-settings-daemon}/libexec/mate-settings-daemon" "$out/libexec/mate-settings-daemon"
  '';

  meta = mate-settings-daemon.meta // {
    priority = -10;
  };
}
