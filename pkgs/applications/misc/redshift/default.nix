{ fetchurl, stdenv, gettext, geoclue, intltool, makeWrapper
, pkgconfig , python, pygobject3, pyxdg }:

let version = "1.10"; in
stdenv.mkDerivation {
  name = "redshift-${version}";
  src = fetchurl {
    sha256 = "19pfk9il5x2g2ivqix4a555psz8mj3m0cvjwnjpjvx0llh5fghjv";
    url = "https://github.com/jonls/redshift/releases/download/v${version}/redshift-${version}.tar.xz";
  };

  buildInputs = [
    gettext intltool makeWrapper pkgconfig python pygobject3 pyxdg
  ];

  preInstall = ''
    substituteInPlace src/redshift-gtk/redshift-gtk python \
      --replace "/usr/bin/env python3" "${python}/bin/${python.executable}"
  '';
/*
  postInstall = ''
    wrapProgram "$out/bin/redshift-gtk" --prefix PYTHONPATH : $PYTHONPATH
  '';
*/
  meta = with stdenv.lib; {
    inherit version;
    description = "Gradually change screen color temperature";
    longDescription = ''
      The color temperature is set according to the position of the
      sun. A different color temperature is set during night and
      daytime. During twilight and early morning, the color
      temperature transitions smoothly from night to daytime
      temperature to allow your eyes to slowly adapt.
    '';
    license = licenses.gpl3Plus;
    homepage = http://jonls.dk/redshift;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mornfall nckx ];
  }; 
}
