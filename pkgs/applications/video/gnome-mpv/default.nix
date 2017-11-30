{ stdenv, fetchFromGitHub, meson, ninja
, gettext, pkgconfig, desktop_file_utils, wrapGAppsHook
, appstream-glib, epoxy, glib, gtk3, mpv
}:

stdenv.mkDerivation rec {
  name = "gnome-mpv-${version}";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "gnome-mpv";
    repo = "gnome-mpv";
    rev = "0d73b33d60050fd32bf8fae77d831548970a0b69"; # upstream forgot to update appdata
    # rev = "v${version}";
    sha256 = "1cjhw3kz163iwj2japhnv354i1lr112xyyfkxw82cwy2554cfim4";
  };

  nativeBuildInputs = [ meson ninja appstream-glib gettext pkgconfig desktop_file_utils wrapGAppsHook ];
  buildInputs = [ epoxy glib gtk3 mpv ];

  enableParallelBuilding = true;

  postPatch = ''
    patchShebangs .
    sed -i '/gtk-update-icon-cache/s/^/#/' meson_post_install.py
  '';

  doCheck = true;
  checkPhase = "meson test";

  meta = with stdenv.lib; {
    description = "Simple GTK+ frontend for the mpv video player";
    longDescription = ''
      GNOME MPV interacts with mpv via the client API exported by libmpv,
      allowing access to mpv's powerful playback capabilities through an
      easy-to-use user interface.
    '';
    homepage = https://github.com/gnome-mpv/gnome-mpv;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
