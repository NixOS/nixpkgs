{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? true
, stdenv, fetchurl, x11 ? null, motif ? null, freetype ? null, t1lib ? null
}:

assert enableGUI -> x11 != null && motif != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert useT1Lib -> t1lib != null;

stdenv.mkDerivation {
  name = "xpdf-3.01";

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xpdf-3.01.tar.gz;
    md5 = "e004c69c7dddef165d768b1362b44268";
  };
  
  buildInputs =
    (if enableGUI then [x11 motif] else []) ++
    (if useT1Lib then [t1lib] else []);
    
  configureFlags =
    [ "--enable-a4-paper" ] /* We obey ISO standards! */
    ++ (if enablePDFtoPPM then [
      ("--with-freetype2-library=${freetype}/lib")
      ("--with-freetype2-includes=${freetype}/include/freetype2")
    ] else []);

}
