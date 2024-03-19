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
  version = "0.2.12";

  src = fetchFromGitHub {
    owner = "poly000";
    repo = "waylyrics";
    rev = "v${version}";
    hash = "sha256-sUhFT3Vq/IjbMir7/AVCU8FyfmoNiZsn2zkqdJkOMFo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ncmapi-0.1.13" = "sha256-NxgF1TV+3hK5oE/DfJnWyc+XmPX3U1UeD+xTkcvDzIA=";
      "qqmusic-rs-0.1.0" = "sha256-woLsO0n+m3EBUI+PRLio7iLp0UPQSliWK0djCSZEaZc=";
    };
  };

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

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
    install -Dm644 io.poly000.waylyrics.desktop -t $out/share/applications
    # Install schema
    install -Dm644 io.poly000.waylyrics.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    # Install icons
    install -d $out/share/icons
    cp -vr res/icons/hicolor $out/share/icons/hicolor
  '';

  meta = with lib; {
    description = "Desktop lyrics with QQ and NetEase Music source";
    mainProgram = "waylyrics";
    homepage = "https://github.com/poly000/waylyrics";
    license = with licenses; [ mit cc-by-40 ];
    maintainers = with maintainers; [ shadowrz aleksana ];
    platforms = platforms.linux;
  };
}
