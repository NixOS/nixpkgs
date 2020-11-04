{ stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, python3
, gettext
, pkgconfig
, desktop-file-utils
, wrapGAppsHook
, appstream-glib
, epoxy
, glib
, gtk3
, mpv
}:

stdenv.mkDerivation rec {
  pname = "celluloid";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "celluloid-player";
    repo = "celluloid";
    rev = "v${version}";
    hash = "sha256-fEZnH8EqU6CykgKINXnKChuBUlisroa97B1vjcx2cWA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    python3
    appstream-glib
    gettext
    pkgconfig
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    epoxy
    glib
    gtk3
    mpv
  ];

  postPatch = ''
    patchShebangs meson-post-install.py src/generate-authors.py
  '';

  doCheck = true;

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "Simple GTK frontend for the mpv video player";
    longDescription = ''
      GNOME MPV interacts with mpv via the client API exported by libmpv,
      allowing access to mpv's powerful playback capabilities through an
      easy-to-use user interface.
    '';
    homepage = "https://github.com/celluloid-player/celluloid";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
