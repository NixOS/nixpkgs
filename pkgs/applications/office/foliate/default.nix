{ stdenv, lib, fetchFromGitHub, meson, gettext, glib, gjs, ninja, python3, gtk3
, webkitgtk_4_1, gsettings-desktop-schemas, wrapGAppsHook, desktop-file-utils
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

  nativeBuildInputs = [ meson ninja python3 wrapGAppsHook gobject-introspection ];

  postPatch = ''
    patchShebangs build-aux/meson/postinstall.py

    substituteInPlace src/main.js \
      --replace "'WebKit2': '4.0'" "'WebKit2': '4.1'"
  '';

  postFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'com.github.johnfactotum.Foliate';" $out/bin/.com.github.johnfactotum.Foliate-wrapped
    ln -s $out/bin/com.github.johnfactotum.Foliate $out/bin/foliate
  '';

  buildInputs = [
    gettext
    glib
    glib-networking
    gjs
    gtk3
    webkitgtk_4_1
    desktop-file-utils
    gsettings-desktop-schemas
  ];

  meta = with lib; {
    description = "A simple and modern GTK eBook reader";
    homepage = "https://johnfactotum.github.io/foliate/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
