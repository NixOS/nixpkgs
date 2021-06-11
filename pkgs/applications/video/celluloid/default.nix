{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, epoxy
, gettext
, glib
, gtk3
, meson
, mpv
, ninja
, nix-update-script
, pkg-config
, python3
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "celluloid";
  version = "0.21";

  src = fetchFromGitHub {
    owner = "celluloid-player";
    repo = "celluloid";
    rev = "v${version}";
    hash = "sha256-1Jeg1uqWxURGKR/Xg4j4roZ9Pg5MR7geyttdzlOU+rA=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    gettext
    meson
    ninja
    pkg-config
    python3
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

  meta = with lib; {
    homepage = "https://github.com/celluloid-player/celluloid";
    description = "Simple GTK frontend for the mpv video player";
    longDescription = ''
      Celluloid (formerly GNOME MPV) is a simple GTK+ frontend for mpv.
      Celluloid interacts with mpv via the client API exported by libmpv,
      allowing access to mpv's powerful playback capabilities.
    '';
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };

  passthru.updateScript = nix-update-script {
    attrPath = pname;
  };
}
