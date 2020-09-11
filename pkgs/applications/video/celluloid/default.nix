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
  version = "0.19";

  src = fetchFromGitHub {
    owner = "celluloid-player";
    repo = "celluloid";
    rev = "v${version}";
    sha256 = "1jdmwljckajqb3ys8azd1nyy49nvq9kb2knrrqdcfnvzq0m5lpqr";
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
