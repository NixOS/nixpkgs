{ lib, stdenv, fetchurl, pkg-config
, alsaLib, fftw, gsl, motif, xorg
}:

stdenv.mkDerivation rec {
  pname = "snd";
  version = "21.1";

  src = fetchurl {
    url = "mirror://sourceforge/snd/snd-${version}.tar.gz";
    sha256 = "1jxvpgx1vqa6bwdzlzyzrjn2swjf9nfhzi9r1r96ivi0870vvjk3";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsaLib fftw gsl motif ]
    ++ (with xorg; [ libXext libXft libXpm libXt ]);

  configureFlags = [ "--with-motif" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Sound editor";
    homepage = "https://ccrma.stanford.edu/software/snd/";
    platforms = platforms.unix;
    license = licenses.free;
    maintainers = with maintainers; [ ];
  };
}
