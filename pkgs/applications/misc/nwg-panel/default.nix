{ lib, fetchFromGitHub
, python3Packages, wrapGAppsHook, gobject-introspection
, gtk-layer-shell, pango, gdk-pixbuf, atk
# Extra packages called by various internal nwg-panel modules
, sway             # swaylock, swaymsg
, systemd          # systemctl
, wlr-randr        # wlr-randr
, nwg-menu         # nwg-menu
, light            # light
, pamixer          # pamixer
, pulseaudio       # pactl
, libdbusmenu-gtk3 # tray
}:

python3Packages.buildPythonApplication rec {
  pname = "nwg-panel";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-panel";
    rev = "v${version}";
    sha256 = "sha256-kQow8jBHxMTgtTaOvq8uT5YjWxml+GoYaoUH3hMQN8g=";
  };

  # No tests
  doCheck = false;

  # Because of wrapGAppsHook
  strictDeps = false;
  dontWrapGApps = true;

  buildInputs = [ atk gdk-pixbuf gtk-layer-shell pango ];
  nativeBuildInputs = [ wrapGAppsHook gobject-introspection ];
  propagatedBuildInputs = (with python3Packages;
    [ i3ipc netifaces psutil pybluez pygobject3 requests dasbus setuptools ])
    # Run-time GTK dependency required by the Tray module
    ++ [ libdbusmenu-gtk3 ];

  postInstall = ''
    mkdir -p $out/share/{applications,pixmaps}
    cp $src/nwg-panel-config.desktop $out/share/applications/
    cp $src/nwg-shell.svg $src/nwg-panel.svg $out/share/pixmaps/
  '';

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix XDG_DATA_DIRS : "$out/share"
      --prefix PATH : "${lib.makeBinPath [ light nwg-menu pamixer pulseaudio sway systemd wlr-randr ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/nwg-piotr/nwg-panel";
    description = "GTK3-based panel for Sway window manager";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ berbiche ];
  };
}
