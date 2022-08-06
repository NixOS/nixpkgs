{ stdenv
, lib
, fetchFromGitHub
, buildGoModule
, wrapGAppsHook
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
  version = "0.20";

  src = fetchFromGitHub {
    owner = "yktoo";
    repo = "ymuse";
    rev = "v${version}";
    sha256 = "sha256-wDQjNBxwxFVFdSswubp4AVD35aXKJ8i0ahk/tgRsDRc=";
  };
  vendorSha256 = "sha256-Ap/nf0NT0VkP2k9U1HzEiptDfLjKkBopP5h0czP3vis=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
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
    install -Dm644 ./resources/ymuse.desktop -t $out/share/applications
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
  };
}
