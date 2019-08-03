{ stdenv, fetchFromGitHub, pkgconfig, meson, ninja, python3, pantheon
, gtk3, gtksourceview, json-glib, gnome3, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "0khf6mwidybfgnq4zmhf3af4w6aicipmi12fvs722fqlf1lrkdmd";
  };

  nativeBuildInputs = [
    meson
    ninja
    pantheon.vala
    pkgconfig
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.libgee
    gtk3
    gtksourceview
    json-glib
    pantheon.elementary-icon-theme
    pantheon.granite
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Stupidly-simple sticky notes applet";
    homepage = https://github.com/lainsce/notejot;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
