{
<<<<<<< HEAD
  gtk4,
=======
  gtk3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  gdk-pixbuf,
  librsvg,
  webp-pixbuf-loader,
  gobject-introspection,
  glib-networking,
  glib,
  shared-mime-info,
  gsettings-desktop-schemas,
<<<<<<< HEAD
  wrapGAppsHook4,
  gtk4-layer-shell,
  adwaita-icon-theme,
  libxkbcommon,
=======
  wrapGAppsHook3,
  gtk-layer-shell,
  adwaita-icon-theme,
  libxkbcommon,
  libdbusmenu-gtk3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  dbus,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  hasFeature = f: features == [ ] || builtins.elem f features;
in
rustPlatform.buildRustPackage rec {
  pname = "ironbar";
<<<<<<< HEAD
  version = "0.18.0";
=======
  version = "0.17.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "JakeStanger";
    repo = "ironbar";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-vhkNdvzY9xd8qmKgKtpVRTdvmS1QxnGKDFCpttqX1GE=";
  };

  cargoHash = "sha256-ptzq0407IaNrXXiksQKXDUbs2wPTz4GHtnCG49EbOcY=";

  buildInputs = [
    gtk4
    gdk-pixbuf
    glib
    gtk4-layer-shell
=======
    hash = "sha256-aph9onWsaEYJqz1bcBNijEexnH0MPLtoblpU9KSbksA=";
  };

  cargoHash = "sha256-puBoRdCd1A8FmEu5PmczgYAdPdTA8FA1CWsh7qWjHzQ=";

  buildInputs = [
    gtk3
    gdk-pixbuf
    glib
    gtk-layer-shell
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    glib-networking
    shared-mime-info
    adwaita-icon-theme
    hicolor-icon-theme
    gsettings-desktop-schemas
    libxkbcommon
    systemd
<<<<<<< HEAD
    dbus
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ]
  ++ lib.optionals (hasFeature "http") [ openssl ]
  ++ lib.optionals (hasFeature "volume") [ libpulseaudio ]
  ++ lib.optionals (hasFeature "cairo") [ luajit ]
<<<<<<< HEAD
=======
  ++ lib.optionals (hasFeature "tray") [ libdbusmenu-gtk3 ]
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ++ lib.optionals (hasFeature "keyboard") [
    libinput
    libevdev
  ];

  nativeBuildInputs = [
    pkg-config
<<<<<<< HEAD
    wrapGAppsHook4
    gobject-introspection
  ];
  propagatedBuildInputs = [ gtk4 ];
=======
    wrapGAppsHook3
    gobject-introspection
  ];
  propagatedBuildInputs = [ gtk3 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
    --suffix PATH : "${lib.makeBinPath [ gtk4 ]}"
=======
    --suffix PATH : "${lib.makeBinPath [ gtk3 ]}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/JakeStanger/ironbar";
    description = "Customizable gtk-layer-shell wlroots/sway bar written in Rust";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "https://github.com/JakeStanger/ironbar";
    description = "Customizable gtk-layer-shell wlroots/sway bar written in Rust";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      yavko
      donovanglover
      jakestanger
    ];
    mainProgram = "ironbar";
  };
}
