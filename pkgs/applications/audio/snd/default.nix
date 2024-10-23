{ lib, stdenv, fetchurl, pkg-config
, alsa-lib, fftw, gsl, motif, xorg
, CoreServices, CoreMIDI
}:

stdenv.mkDerivation rec {
  pname = "snd";
  version = "24.8";

  src = fetchurl {
    url = "mirror://sourceforge/snd/snd-${version}.tar.gz";
    sha256 = "sha256-iH/y2dHeQL3ZHwKl5qkrXpSDgrqI/U31BwpwFAzBzEE=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ fftw gsl motif ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ alsa-lib ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices CoreMIDI ]
    ++ (with xorg; [ libXext libXft libXpm libXt ]);

  configureFlags = [ "--with-motif" ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Sound editor";
    homepage = "https://ccrma.stanford.edu/software/snd/";
    platforms = platforms.unix;
    license = licenses.free;
    maintainers = [ ];
    mainProgram = "snd";
  };
}
