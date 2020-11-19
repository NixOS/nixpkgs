{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja, python3
, wrapGAppsHook, vala, shared-mime-info
, cairo, pantheon, glib, gtk3, libxml2, libgee, libarchive
, discount, gtksourceview3
, hicolor-icon-theme # for setup-hook
}:

stdenv.mkDerivation rec {
  pname = "minder";
  version = "1.11.3";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = pname;
    rev = version;
    sha256 = "137kyf82n5a2v0cm9q02rhv8rmbjgnj60h64prq90h0d42prj3gd";
  };

  nativeBuildInputs = [ pkgconfig meson ninja python3 wrapGAppsHook vala shared-mime-info ];
  buildInputs = [ cairo pantheon.granite glib gtk3 libxml2 libgee libarchive hicolor-icon-theme discount gtksourceview3 ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  postFixup = ''
    for x in $out/bin/*; do
      ln -vrs $x "$out/bin/''${x##*.}"
    done
  '';

  meta = with stdenv.lib; {
    description = "Mind-mapping application for Elementary OS";
    homepage = "https://github.com/phase1geo/Minder";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dtzWill ];
  };
}

