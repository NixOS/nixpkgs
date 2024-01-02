{ gtk3
, gdk-pixbuf
, librsvg
, webp-pixbuf-loader
, gobject-introspection
, glib-networking
, glib
, shared-mime-info
, gsettings-desktop-schemas
, wrapGAppsHook
, gtk-layer-shell
, gnome
, libxkbcommon
, openssl
, pkg-config
, hicolor-icon-theme
, rustPlatform
, lib
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ironbar";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "ironbar";
    rev = "v${version}";
    hash = "sha256-e79eJGc/kxQjRwa1HnF7V/pCbrMTstJsBOl1Luo6i0g=";
  };

  cargoHash = "sha256-N8uAisQ50W/9zCr9bRX6tZ0slEoe1zCEMDXuvmoWEs4=";

  buildInputs = [
    gtk3
    gdk-pixbuf
    glib
    gtk-layer-shell
    glib-networking
    shared-mime-info
    gnome.adwaita-icon-theme
    hicolor-icon-theme
    gsettings-desktop-schemas
    libxkbcommon
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
    gobject-introspection
  ];

  propagatedBuildInputs = [
    gtk3
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${webp-pixbuf-loader}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"

      # gtk-launch
      --suffix PATH : "${lib.makeBinPath [ gtk3 ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/JakeStanger/ironbar";
    description = "Customizable gtk-layer-shell wlroots/sway bar written in Rust";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yavko donovanglover jakestanger ];
    mainProgram = "ironbar";
  };
}
