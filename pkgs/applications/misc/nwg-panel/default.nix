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
<<<<<<< HEAD
, playerctl
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

python3Packages.buildPythonApplication rec {
  pname = "nwg-panel";
<<<<<<< HEAD
  version = "0.9.12";
=======
  version = "0.7.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = "nwg-panel";
<<<<<<< HEAD
    rev = "v${version}";
    hash = "sha256-lCo58v2UGolFagci2xHcieTUvqNc1KKNj3Z92oG5WPI=";
=======
    rev = "refs/tags/v${version}";
    sha256 = "sha256-HGbPBHf5PIjbuMSd/2fFSCLQ/7s1Xbys+KoGXctQOvM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # No tests
  doCheck = false;

  # Because of wrapGAppsHook
  strictDeps = false;
  dontWrapGApps = true;

<<<<<<< HEAD
  buildInputs = [ atk gdk-pixbuf gtk-layer-shell pango playerctl ];
=======
  buildInputs = [ atk gdk-pixbuf gtk-layer-shell pango ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ludovicopiero ];
    mainProgram = "nwg-panel";
=======
    maintainers = with maintainers; [ ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
