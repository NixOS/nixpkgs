{
  mkKdeDerivation,
  pkg-config,
  qtsensors,
  qtwayland,
  wayland-protocols,
  dbus,
}:
mkKdeDerivation {
  pname = "kscreen";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    qtsensors
    qtwayland

    wayland-protocols
  ];

  postFixup = ''
    substituteInPlace $out/share/kglobalaccel/org.kde.kscreen.desktop \
      --replace-fail dbus-send ${dbus}/bin/dbus-send
  '';
  meta.mainProgram = "kscreen-console";
}
