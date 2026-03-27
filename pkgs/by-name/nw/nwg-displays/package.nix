{
  lib,
  fetchFromGitHub,
  atk,
  gdk-pixbuf,
  gobject-introspection,
  gtk-layer-shell,
  gtk3,
  pango,
  python3Packages,
  wrapGAppsHook3,
  hyprlandSupport ? true,
  wlr-randr,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "nwg-displays";
  version = "0.3.28";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-displays";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PiE3d/o3ym2WmOzRsq7VRKt8TDQ4KCnePVObeI7+oKo=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    atk
    gdk-pixbuf
    gtk-layer-shell
    pango
    python3Packages.gst-python
    python3Packages.i3ipc
    python3Packages.pygobject3
  ]
  ++ lib.optionals hyprlandSupport [
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
    maintainers = with lib.maintainers; [ qf0xb ];
    mainProgram = "nwg-displays";
  };
})
