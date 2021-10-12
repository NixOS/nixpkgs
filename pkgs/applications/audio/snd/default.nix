{ lib, stdenv, fetchurl, pkg-config
, alsa-lib, fftw, gsl, motif, xorg
}:

stdenv.mkDerivation rec {
  pname = "snd";
  version = "21.7";

  src = fetchurl {
    url = "mirror://sourceforge/snd/snd-${version}.tar.gz";
    sha256 = "sha256-GjaPZmJfodvYvhObGcBDRN0mIyc6Vxycd0BZGHdvoJA=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ alsa-lib fftw gsl motif ]
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
