{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, wrapGAppsHook4
, openssl
, dbus
}:

rustPlatform.buildRustPackage rec {
  pname = "waylyrics";
  version = "0.3.10";

  src = fetchFromGitHub {
    owner = "waylyrics";
    repo = "waylyrics";
    rev = "v${version}";
    hash = "sha256-JqCnVkqua/qOZjE+XKj3PyrGwqk7IToYOhLN78fKdq0=";
  };

  cargoHash = "sha256-fVwY+lkfg/O1sPM0C7NOdb8/pln96vBcmCAWh0pEPHI=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 ];
  buildInputs = [ openssl dbus ];

  checkFlags = [
    "--skip=tests::netease_lyric::get_netease_lyric" # Requires network access
  ];

  WAYLYRICS_THEME_PRESETS_DIR = "${placeholder "out"}/share/waylyrics/themes";

  postInstall = ''
    # Install themes
    install -d $WAYLYRICS_THEME_PRESETS_DIR
    cp -vr themes/* $WAYLYRICS_THEME_PRESETS_DIR
    # Install desktop entry
    install -Dm644 metainfo/io.github.waylyrics.Waylyrics.desktop -t $out/share/applications
    # Install schema
    install -Dm644 metainfo/io.github.waylyrics.Waylyrics.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    # Install metainfo
    install -Dm644 metainfo/io.github.waylyrics.Waylyrics.metainfo.xml -t $out/share/metainfo
    # Install icons
    install -d $out/share/icons
    cp -vr res/icons/hicolor $out/share/icons/hicolor
    # Install translations
    pushd locales
    for po in $(find . -type f -name '*.po')
    do
      install -d $(dirname "$out/share/locale/$po")
      msgfmt -o $out/share/locale/''${po%.po}.mo $po
    done
    popd
  '';

  meta = with lib; {
    description = "Desktop lyrics with QQ and NetEase Music source";
    mainProgram = "waylyrics";
    homepage = "https://github.com/waylyrics/waylyrics";
    license = with licenses; [ mit cc-by-40 ];
    maintainers = with maintainers; [ shadowrz aleksana ];
    platforms = platforms.linux;
  };
}
