{
  wrapGAppsHook3,
  lib,
  python3Packages,
  fetchFromGitHub,
  rofi,
  gobject-introspection,
}:

python3Packages.buildPythonApplication rec {
  pname = "plasma-hud";
  version = "22.01.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "Zren";
    repo = "plasma-hud";
    rev = version;
    hash = "sha256-HEAvwQSROQtJAZdiDObu9qbpgJlkJdks2v95Xjh5520=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs =
    (with python3Packages; [
      dbus-python
      pygobject3
      setproctitle
      xlib
    ])
    ++ [ rofi ];

  postPatch = ''
    sed -i "s:/usr/lib/plasma-hud:$out/bin:" etc/xdg/autostart/plasma-hud.desktop
  '';

  installPhase = ''
    runHook preInstall

    install -Dm555 usr/lib/plasma-hud/plasma-hud -t $out/bin
    cp -r etc -t $out

    runHook postInstall
  '';

  meta = {
    license = lib.licenses.gpl2Only;
    homepage = "https://github.com/Zren/plasma-hud";
    platforms = lib.platforms.unix;
    description = "Run menubar commands, much like the Unity 7 Heads-Up Display (HUD)";
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "plasma-hud";
  };
}
