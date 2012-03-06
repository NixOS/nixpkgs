{ stdenv, fetchurl
}:

stdenv.mkDerivation {
  name = "libxpdf-3.02pl4";

  src = fetchurl {
    url = ftp://ftp.foolabs.com/pub/xpdf/xpdf-3.02.tar.gz;
    sha256 = "000zq4ddbwyxiki4vdwpmxbnw5n9hsg9hvwra2p33hslyib7sfmk";
  };
  
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
    ./libxpdf.patch
  ];

  installPhase = ''
    mkdir -p $out/lib/goo
    mkdir -p $out/lib/fofi
    mkdir -p $out/lib/xpdf
    mkdir -p $out/include

    cp -v goo/libGoo.a $out/lib/goo
    cp -v fofi/libfofi.a $out/lib/fofi
    cp -v xpdf/libxpdf.a $out/lib/xpdf
    
    cp -v *.h $out/include
    cp -v goo/*.h $out/include
    cp -v fofi/*.h $out/include
    cp -v xpdf/*.h $out/include
  '';
    
}
