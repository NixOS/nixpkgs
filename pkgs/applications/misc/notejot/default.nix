{ stdenv, fetchFromGitHub, pkgconfig, meson, ninja, python3, pantheon
, gtk3, gtksourceview, json-glib, libgee, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "notejot";
  version = "1.5.8";

  src = fetchFromGitHub {
    owner = "lainsce";
    repo = pname;
    rev = version;
    sha256 = "1v7f4xy5iwdjyf4416qpiwzifi68n466faia1hxzsq18fb1ri0af";
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
    gtk3
    gtksourceview
    json-glib
    libgee
    pantheon.elementary-icon-theme
    pantheon.granite
  ];

  postPatch = ''
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
