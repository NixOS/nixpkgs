{ stdenv, lib, fetchFromGitHub, meson, gettext, glib, gjs, ninja, python3, gtk3
, webkitgtk, gsettings-desktop-schemas, wrapGAppsHook, desktop-file-utils
, gobject-introspection, glib-networking }:

stdenv.mkDerivation rec {
  pname = "foliate";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "johnfactotum";
    repo = pname;
    rev = version;
    sha256 = "sha256-Pr2YA2MHXD4W7lyCxGAVLKyoZarZ8t92RSkWle3LNuc=";
  };

  nativeBuildInputs = [ meson ninja python3 wrapGAppsHook ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py
  '';

  postFixup = ''
    echo "fixing wrapper"
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'com.github.johnfactotum.Foliate';" $out/bin/.com.github.johnfactotum.Foliate-wrapped
    ln -s $out/bin/com.github.johnfactotum.Foliate $out/bin/foliate
  '';

  buildInputs = [
    gettext
    glib
    glib-networking
    gjs
    gtk3
    webkitgtk
    desktop-file-utils
    gobject-introspection
    gsettings-desktop-schemas
  ];

  meta = with lib; {
    description = "A simple and modern GTK eBook reader";
    homepage = "https://johnfactotum.github.io/foliate/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
