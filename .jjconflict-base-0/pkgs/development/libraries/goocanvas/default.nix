{ lib, stdenv, fetchurl, gtk2, cairo, glib, pkg-config, gnome }:

stdenv.mkDerivation rec {
  pname = "goocanvas";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.bz2";
    sha256 = "07kicpcacbqm3inp7zq32ldp95mxx4kfxpaazd0x5jk7hpw2w1qw";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk2 cairo glib ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
      freeze = true;
    };
  };

  meta = with lib; {
    description = "Canvas widget for GTK based on the the Cairo 2D library";
    homepage = "https://gitlab.gnome.org/Archive/goocanvas";
    license = licenses.lgpl2;
    platforms = lib.platforms.unix;
  };
}
