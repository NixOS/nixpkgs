{
  gtk4,
  gdk-pixbuf,
  librsvg,
  webp-pixbuf-loader,
  gobject-introspection,
  glib-networking,
  glib,
  shared-mime-info,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  gtk4-layer-shell,
  adwaita-icon-theme,
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
  libinput,
  libevdev,
  features ? [ ],
  systemd,
  dbus,
}:

let
  hasFeature = f: features == [ ] || builtins.elem f features;
in
rustPlatform.buildRustPackage rec {
  pname = "ironbar";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "ironbar";
    rev = "v${version}";
    hash = "sha256-vhkNdvzY9xd8qmKgKtpVRTdvmS1QxnGKDFCpttqX1GE=";
  };

  cargoHash = "sha256-ptzq0407IaNrXXiksQKXDUbs2wPTz4GHtnCG49EbOcY=";

  buildInputs = [
    gtk4
    gdk-pixbuf
    glib
    gtk4-layer-shell
    glib-networking
    shared-mime-info
    adwaita-icon-theme
    hicolor-icon-theme
    gsettings-desktop-schemas
    libxkbcommon
    systemd
    dbus
  ]
  ++ lib.optionals (hasFeature "http") [ openssl ]
  ++ lib.optionals (hasFeature "volume") [ libpulseaudio ]
  ++ lib.optionals (hasFeature "cairo") [ luajit ]
  ++ lib.optionals (hasFeature "keyboard") [
    libinput
    libevdev
  ];

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    gobject-introspection
  ];
  propagatedBuildInputs = [ gtk4 ];

  runtimeDeps = [ luajitPackages.lgi ];

  buildNoDefaultFeatures = features != [ ];
  buildFeatures = features;

  gappsWrapperArgs = ''
    # Thumbnailers
    --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
    --prefix XDG_DATA_DIRS : "${librsvg}/share"
    --prefix XDG_DATA_DIRS : "${webp-pixbuf-loader}/share"
    --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"

    # gtk-launch
    --suffix PATH : "${lib.makeBinPath [ gtk4 ]}"
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

  meta = {
    homepage = "https://github.com/JakeStanger/ironbar";
    description = "Customizable gtk-layer-shell wlroots/sway bar written in Rust";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      yavko
      donovanglover
      jakestanger
    ];
    mainProgram = "ironbar";
  };
}
