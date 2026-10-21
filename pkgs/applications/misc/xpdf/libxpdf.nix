{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "libxpdf";
  version = "3.02pl5";

  src = fetchurl {
    url = "https://dl.xpdfreader.com/old/xpdf-3.02.tar.gz";
    hash = "sha256-szp9VvRUwzGuUJlvmJ6GyRZuV6+Xt03ijN3z1RrBHwA=";
  };

  patches = [
    (fetchurl {
      url = "https://dl.xpdfreader.com/old/xpdf-3.02pl1.patch";
      hash = "sha256-WPYTsAtBSoaqd2t2/NiZu0FeTuTtwhhMinxO0QBNu/M=";
    })
    (fetchurl {
      url = "https://dl.xpdfreader.com/old/xpdf-3.02pl2.patch";
      hash = "sha256-0cHYh7C4pSg/BPgl5E8IXy6S2ve1GIiazxvInqB+2dk=";
    })
    (fetchurl {
      url = "https://dl.xpdfreader.com/old/xpdf-3.02pl3.patch";
      hash = "sha256-WUzo+9I7/ynqzd+uNTPGPH6GtKJPfUXkTxk309GeU0s=";
    })
    (fetchurl {
      url = "https://dl.xpdfreader.com/old/xpdf-3.02pl4.patch";
      hash = "sha256-sIRDlUETGHZu91CYd4f3eCMelLwV8E9/fRb0H9WBiLA=";
    })
    (fetchurl {
      url = "https://dl.xpdfreader.com/old/xpdf-3.02pl5.patch";
      hash = "sha256-kvyzCDoZ43swlpeAQ/rqjHd+eq7KODS4Mtmbwq8xcbo=";
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

  meta = {
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
  };
}
