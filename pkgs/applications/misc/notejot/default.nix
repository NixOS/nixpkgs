{ stdenv, fetchFromGitHub, vala_0_40, pkgconfig, meson, ninja, python3, granite
, gtk3, gnome3, gtksourceview, json-glib, gobject-introspection, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "1.5.2";

  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "17rqyckq7z5cxj3mbfrar1zzgwbzhrx87ps7mm6bf798hwflm9qk";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    pkgconfig
    python3
    vala_0_40 # should be `elementary.vala` when elementary attribute set is merged
    wrapGAppsHook
  ];

  buildInputs = [
    gnome3.defaultIconTheme # should be `elementary.defaultIconTheme`when elementary attribute set is merged
    gnome3.libgee
    granite
    gtk3
    gtksourceview
    json-glib
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
