{ lib
, fetchFromGitHub
, buildGoModule
, wrapGAppsHook3
, pkg-config
, glib
, gobject-introspection
, gtk3
, gdk-pixbuf
, gettext
, librsvg
}:

buildGoModule rec {
  pname = "ymuse";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "yktoo";
    repo = "ymuse";
    rev = "v${version}";
    hash = "sha256-WbIeqOAhdqxU8EvHEsG7ASwy5xZG1domZKT5ccOggHg=";
  };

  vendorHash = "sha256-YT4JiieVI6/t4inezE3K2WQBI51W+/MoWr7R/uBzn+8=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    glib
    gobject-introspection
    gdk-pixbuf
    gettext
  ];

  buildInputs = [
    gtk3
    librsvg
  ];

  postInstall = ''
    install -Dm644 ./resources/com.yktoo.ymuse.desktop -t $out/share/applications
    install -Dm644 ./resources/metainfo/com.yktoo.ymuse.metainfo.xml -t $out/share/metainfo
    cp -r ./resources/icons $out/share

    app_id="ymuse"
    find ./resources/i18n -type f -name '*.po' |
    while read file; do
        # Language is the filename without the extension
        lang="$(basename "$file")"
        lang="''${lang%.*}"

        # Create the target dir if needed
        target_dir="$out/share/locale/$lang/LC_MESSAGES"
        mkdir -p "$target_dir"

        # Compile the .po into a .mo
        echo "Compiling $file" into "$target_dir/$app_id.mo"
        msgfmt "$file" -o "$target_dir/$app_id.mo"
    done
  '';

  # IDK how to deal with tests that open up display.
  doCheck = false;

  meta = with lib; {
    homepage = "https://yktoo.com/en/software/ymuse/";
    description = "GTK client for Music Player Daemon (MPD)";
    license = licenses.asl20;
    maintainers = with maintainers; [ foo-dogsquared ];
    mainProgram = "ymuse";
    platforms = platforms.unix;
  };
}
