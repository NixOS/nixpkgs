{ lib
, fetchFromGitHub
, atk
, gdk-pixbuf
, gobject-introspection
, gtk-layer-shell
, gtk3
, pango
, python310Packages
, wrapGAppsHook
, hyprlandSupport ? false
, wlr-randr
}:

python310Packages.buildPythonApplication rec {
  pname = "nwg-displays";
  version = "0.3.8";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-displays";
    rev = "v${version}";
    hash = "sha256-9v5TQTliUEnynoGDf1UXsQ9Ym7x2gPmx4QiRJH5BId4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    atk
    gdk-pixbuf
    gtk-layer-shell
    pango
    python310Packages.gst-python
    python310Packages.i3ipc
    python310Packages.pygobject3
  ] ++ lib.optionals hyprlandSupport [
    wlr-randr
  ];

  dontWrapGApps = true;

  postInstall = ''
    install -Dm444 nwg-displays.svg -t $out/share/icons/hicolor/scalable/apps
    install -Dm444 nwg-displays.desktop -t $out/share/applications
  '';

  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}");
  '';

  # Upstream has no tests
  doCheck = false;

  meta = {
    homepage = "https://github.com/nwg-piotr/nwg-displays";
    description = "Output management utility for Sway and Hyprland";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    mainProgram = "nwg-displays";
  };
}
