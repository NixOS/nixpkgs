{ fetchurl, stdenv, gettext, intltool, pkgconfig, makeWrapper
, geoclue, python, pygobject3, pyxdg
, libdrm, libX11, libxcb, libXxf86vm
, guiSupport ? true
, drmSupport ? true
, randrSupport ? true
, vidModeSupport ? true
}:

let
  version = "1.10";
  mkFlag = flag: name: if flag then "--enable-${name}" else "--disable-${name}";
in
stdenv.mkDerivation {
  name = "redshift-${version}";
  src = fetchurl {
    sha256 = "19pfk9il5x2g2ivqix4a555psz8mj3m0cvjwnjpjvx0llh5fghjv";
    url = "https://github.com/jonls/redshift/releases/download/v${version}/redshift-${version}.tar.xz";
  };

  buildInputs = [ geoclue ]
    ++ stdenv.lib.optional guiSupport [ python pygobject3 pyxdg ]
    ++ stdenv.lib.optional drmSupport [ libdrm ]
    ++ stdenv.lib.optional randrSupport [ libxcb ]
    ++ stdenv.lib.optional vidModeSupport [ libX11 libXxf86vm ];
  nativeBuildInputs = [ gettext intltool makeWrapper pkgconfig ];

  configureFlags = [
    (mkFlag guiSupport "gui")
    (mkFlag drmSupport "drm")
    (mkFlag randrSupport "randr")
    (mkFlag vidModeSupport "vidmode")
  ];

  preInstall = stdenv.lib.optionalString guiSupport ''
    substituteInPlace src/redshift-gtk/redshift-gtk python \
      --replace "/usr/bin/env python3" "${python}/bin/${python.executable}"
  '';

  postInstall = stdenv.lib.optionalString guiSupport ''
    wrapProgram "$out/bin/redshift-gtk" --prefix PYTHONPATH : "$PYTHONPATH"
  '';

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
