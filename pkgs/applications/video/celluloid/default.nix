{ lib
, stdenv
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, glib
, gtk4
, libepoxy
, libadwaita
, meson
, mpv
, ninja
, nix-update-script
, pkg-config
, python3
, wrapGAppsHook4
}:

stdenv.mkDerivation rec {
  pname = "celluloid";
  version = "0.24";

  src = fetchFromGitHub {
    owner = "celluloid-player";
    repo = "celluloid";
    rev = "v${version}";
    hash = "sha256-8Y/dCeoS29R1UHwmLOp0d+JNNC4JH5pLpiqfBZU+kLI=";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libepoxy
    mpv
  ];

  postPatch = ''
    patchShebangs meson-post-install.py src/generate-authors.py
  '';

  doCheck = true;

  passthru.updateScript = nix-update-script { };

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
}
