{ stdenv, fetchFromGitHub, fftw, gtk2, lv2, libsamplerate, libsndfile, pkgconfig, zita-convolver }:

stdenv.mkDerivation rec {
  name = "ir.lv2-${version}";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "tomszilagyi";
    repo = "ir.lv2";
    rev = "${version}";
    sha256 = "16vy06qb0vgwg4yx15grzh5m2q3cbzm3jd0p37g2qb8rgvjhladg";
  };

  buildInputs = [ fftw gtk2 lv2 libsamplerate libsndfile zita-convolver ];

  nativeBuildInputs = [  pkgconfig ];

  postBuild = "make convert4chan";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir "$out/include"
    mkdir -p "$out/share/doc"

    make PREFIX="$out" install
    install -Dm755 convert4chan "$out/bin/convert4chan"
  '';

  meta = with stdenv.lib; {
    homepage = http://factorial.hu/plugins/lv2/ir;
    description = "Zero-latency, realtime, high performance signal convolver especially for creating reverb effects";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
