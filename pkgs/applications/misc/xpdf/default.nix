{ enableGUI ? true, enablePDFtoPPM ? true, useT1Lib ? true
, stdenv, fetchurl, x11 ? null, motif ? null, freetype ? null, t1lib ? null
, base14Fonts ? null
}:

assert enableGUI -> x11 != null && motif != null && freetype != null;
assert enablePDFtoPPM -> freetype != null;
assert useT1Lib -> t1lib != null;

stdenv.mkDerivation {
  name = "xpdf-3.02pl4";

  src = fetchurl {
    url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02.tar.gz;
    sha256 = "000zq4ddbwyxiki4vdwpmxbnw5n9hsg9hvwra2p33hslyib7sfmk";
  };
  
  buildInputs =
    (if enableGUI then [x11 motif] else []) ++
    (if useT1Lib then [t1lib] else []);

  patches = [
    (fetchurl {
      url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl1.patch;
      sha256 = "1wxv9l0d2kkwi961ihpdwi75whdvk7cgqxkbfym8cjj11fq17xjq";
    })
    (fetchurl {
      url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl2.patch;
      sha256 = "1nfrgsh9xj0vryd8h65myzd94bjz117y89gq0hzji9dqn23xihfi";
    })
    (fetchurl {
      url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl3.patch;
      sha256 = "0jskkv8x6dqr9zj4azaglas8cziwqqrkbbnzrpm2kzrvsbxyhk2r";
    })
    (fetchurl {
      url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02pl4.patch;
      sha256 = "1c48h7aizx0ngmzlzw0mpja1w8vqyy3pg62hyxp7c60k86al715h";
    })
    ./xpdf-3.02-protection.patch
  ];
    
  configureFlags =
    [ "--enable-a4-paper" ] /* We obey ISO standards! */
    ++ (if enablePDFtoPPM then [
      "--with-freetype2-library=${freetype}/lib"
      "--with-freetype2-includes=${freetype}/include/freetype2"
    ] else []);

  postInstall = "
    if test -n \"${base14Fonts}\"; then
      substituteInPlace $out/etc/xpdfrc \\
        --replace /usr/local/share/ghostscript/fonts ${base14Fonts} \\
        --replace '#displayFontT1' displayFontT1
    fi
  ";
}
