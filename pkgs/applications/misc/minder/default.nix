{ stdenv, fetchFromGitHub
, pkgconfig, meson, ninja, python3
, wrapGAppsHook, vala, shared-mime-info
, cairo, pantheon, glib, gtk3, libxml2, libgee, libarchive
, discount, gtksourceview3
, hicolor-icon-theme # for setup-hook
}:

stdenv.mkDerivation rec {
  pname = "minder";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "phase1geo";
    repo = pname;
    rev = version;
    sha256 = "0y30gdnx270m857iijhgdv7a2nqxmmd8w6kfhd80763ygk17xk1r";
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

