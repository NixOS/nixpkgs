{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, meson, ninja, python3
, gtk3, desktop-file-utils, gtksourceview, webkitgtk, gtkspell3, pantheon
, gnome3, discount, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "quilter";
  version = "1.6.8";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "07i9pivpddgixn1wzbr15gvzf0n5pklx0gkjjaa35kvj2z8k31x5";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    pantheon.vala
    wrapGAppsHook
  ];

  buildInputs = [
    discount
    pantheon.elementary-icon-theme
    pantheon.granite
    gnome3.libgee
    gtk3
    gtksourceview
    gtkspell3
    webkitgtk
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Focus on your writing - designed for elementary OS";
    homepage = https://github.com/lainsce/quilter;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ worldofpeace ];
    platforms = platforms.linux;
  };
}
