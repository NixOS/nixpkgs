{ stdenv, fetchFromGitHub, fetchpatch, meson, ninja, python3
, gettext, pkgconfig, desktop-file-utils, wrapGAppsHook
, appstream-glib, epoxy, glib, gtk3, mpv
}:

stdenv.mkDerivation rec {
  pname = "gnome-mpv";
  version = "0.16";

  src = fetchFromGitHub {
    owner = "celluloid-player";
    repo = "celluloid";
    rev = "v${version}";
    sha256 = "1fj5mr1dwd07jpnigk7z85xdm6yaf7spbvf60aj3mz12m05b1b2w";
  };

  nativeBuildInputs = [ meson ninja python3 appstream-glib gettext pkgconfig desktop-file-utils wrapGAppsHook ];
  buildInputs = [ epoxy glib gtk3 mpv ];

  patches = [
    # fix appstream validation in sandbox
    # https://github.com/celluloid-player/celluloid/pull/437
    (fetchpatch {
      url = https://github.com/celluloid-player/celluloid/commit/5a0b2e892bb715278d309c859a7e521d64433d85.patch;
      sha256 = "0naci8lr6128yilal39h46yvq9x3la7g7fhvr5xlwyh30iqrbm3i";
    })
  ];

  postPatch = ''
    patchShebangs meson_post_install.py
    patchShebangs src/generate_authors.py
    sed -i '/gtk-update-icon-cache/s/^/#/' meson_post_install.py
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Simple GTK+ frontend for the mpv video player";
    longDescription = ''
      GNOME MPV interacts with mpv via the client API exported by libmpv,
      allowing access to mpv's powerful playback capabilities through an
      easy-to-use user interface.
    '';
    homepage = "https://github.com/celluloid-player/celluloid";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
