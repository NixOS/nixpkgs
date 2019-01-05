{ stdenv, fetchFromGitHub, fetchpatch, vala_0_40, pkgconfig, meson, ninja, python3
, granite, gtk3, desktop-file-utils, gnome3, gtksourceview, webkitgtk, gtkspell3
, discount, gobject-introspection, wrapGAppsHook }:

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
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    wrapGAppsHook
  ];

  buildInputs = [
    discount
    gnome3.defaultIconTheme # should be `elementary.defaultIconTheme`when elementary attribute set is merged
    gnome3.libgee
    granite
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
