{ lib, fetchFromGitHub, rustPlatform, gtk4, pkg-config, openssl, dbus, wrapGAppsHook4, glib, makeDesktopItem, copyDesktopItems }:

rustPlatform.buildRustPackage rec {
  pname = "waylyrics";
  version = "unstable-2023-05-14";

  src = fetchFromGitHub {
    owner = "poly000";
    repo = pname;
    rev = "7e8bd99e1748a5448c1a5c49f0664bd96fbf965e";
    hash = "sha256-vSYtLsLvRHCCHxomPSHifXFZKjkFrlskNp7IlFflrUU=";
  };

  cargoHash = "sha256-dpJa0T6xapCBPM5fWbSDEhBlZ55c3Sr5oTnu58B/voM=";

  nativeBuildInputs = [ pkg-config wrapGAppsHook4 copyDesktopItems ];
  buildInputs = [ gtk4 openssl dbus glib ];

  RUSTC_BOOTSTRAP = 1;

  doCheck = false; # No tests defined in the project.

  WAYLYRICS_DEFAULT_CONFIG = "${placeholder "out"}/share/waylyrics/config.toml";
  WAYLYRICS_THEME_PRESETS_DIR = "${placeholder "out"}/share/waylyrics/themes";

  desktopItems = [
    (makeDesktopItem {
      name = "io.poly000.waylyrics";
      exec = "waylyrics";
      comment = "Simple on screen lyrics for MPRIS-friendly players";
      type = "Application";
      icon = "io.poly000.waylyrics";
      desktopName = "Waylyrics";
      terminal = false;
      categories = [ "Audio" "AudioVideo" ];
    })
  ];

  postInstall = ''
    $out/bin/gen_config_example
    mkdir -p $out/share/waylyrics
    install -Dm644 config.toml $WAYLYRICS_DEFAULT_CONFIG
    cp -vr themes $out/share/waylyrics/
    rm $out/bin/gen_config_example # Unnecessary for end users
    # Install schema
    install -Dm644 io.poly000.waylyrics.gschema.xml -t $out/share/gsettings-schemas/$name/glib-2.0/schemas
    glib-compile-schemas $out/share/gsettings-schemas/$name/glib-2.0/schemas/
    # Install icons
    cp -vr res/icons $out/share/
  '';

  meta = with lib; {
    description = "On screen lyrics for Wayland with NetEase Music source";
    homepage = "https://github.com/poly000/waylyrics";
    license = licenses.mit;
    maintainers = [ maintainers.shadowrz ];
    platforms = platforms.linux;
  };
}
