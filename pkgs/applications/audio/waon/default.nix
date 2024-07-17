{
  lib,
  stdenv,
  fetchFromGitHub,
  fftw,
  gtk2,
  libao,
  libsamplerate,
  libsndfile,
  ncurses,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "waon";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "kichiki";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xmq8d2rj58xbp4rnyav95y1vnz3r9s9db7xxfa2rd0ilq0ps4y7";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fftw
    gtk2
    libao
    libsamplerate
    libsndfile
    ncurses
  ];

  installPhase = ''
    install -Dt $out/bin waon pv gwaon
  '';

  meta = with lib; {
    description = "A Wave-to-Notes transcriber";
    homepage = "https://kichiki.github.io/WaoN/";
    license = licenses.gpl2;
    maintainers = [ maintainers.puckipedia ];
    platforms = platforms.all;
  };
}
