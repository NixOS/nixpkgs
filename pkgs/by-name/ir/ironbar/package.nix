{
  gtk3,
  gdk-pixbuf,
  librsvg,
  webp-pixbuf-loader,
  gobject-introspection,
  glib-networking,
  glib,
  shared-mime-info,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  gtk-layer-shell,
  gnome,
  libxkbcommon,
  openssl,
  pkg-config,
  hicolor-icon-theme,
  rustPlatform,
  lib,
  fetchFromGitHub,
  luajit,
  luajitPackages,
  libpulseaudio,
  features ? [ ],
}:

let
  hasFeature = f: features == [ ] || builtins.elem f features;
in
rustPlatform.buildRustPackage rec {
  pname = "ironbar";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "ironbar";
    rev = "v${version}";
    hash = "sha256-TPbvKQdoGfZMzp+fl72vy6MtRV1yGcOG/es67VOA0xw=";
  };

  cargoHash = "sha256-+9R505xyEycv5Dav4ZCh1BiYRp3U1I9yBDqSPefo9uY=";

  buildInputs =
    [
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
    ]
    ++ lib.optionals (hasFeature "http") [ openssl ]
    ++ lib.optionals (hasFeature "volume") [ libpulseaudio ]
    ++ lib.optionals (hasFeature "cairo") [ luajit ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    gobject-introspection
  ];
  propagatedBuildInputs = [ gtk3 ];

  runtimeDeps = [ luajitPackages.lgi ];

  buildNoDefaultFeatures = features != [ ];
  buildFeatures = features;

  gappsWrapperArgs =
    ''
      # Thumbnailers
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      --prefix XDG_DATA_DIRS : "${webp-pixbuf-loader}/share"
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"

      # gtk-launch
      --suffix PATH : "${lib.makeBinPath [ gtk3 ]}"
    ''
    + lib.optionalString (hasFeature "cairo") ''
      --prefix LUA_PATH : "./?.lua;${luajitPackages.lgi}/share/lua/5.1/?.lua;${luajitPackages.lgi}/share/lua/5.1/?/init.lua;${luajit}/share/lua/5.1/\?.lua;${luajit}/share/lua/5.1/?/init.lua"
      --prefix LUA_CPATH : "./?.so;${luajitPackages.lgi}/lib/lua/5.1/?.so;${luajit}/lib/lua/5.1/?.so;${luajit}/lib/lua/5.1/loadall.so"
    '';

  preFixup = ''
    gappsWrapperArgs+=(
      ${gappsWrapperArgs}
    )
  '';

  meta = with lib; {
    homepage = "https://github.com/JakeStanger/ironbar";
    description = "Customizable gtk-layer-shell wlroots/sway bar written in Rust";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      yavko
      donovanglover
      jakestanger
    ];
    mainProgram = "ironbar";
  };
}
