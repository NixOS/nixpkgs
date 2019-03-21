{ stdenv, fetchFromGitHub, fftw, gtk2, lv2, libsamplerate, libsndfile, pkgconfig, zita-convolver }:

stdenv.mkDerivation rec {
  name = "ir.lv2-${version}";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "tomszilagyi";
    repo = "ir.lv2";
    rev = "${version}";
    sha256 = "1p6makmgr898fakdxzl4agh48qqwgv1k1kwm8cgq187n0mhiknp6";
  };

  buildInputs = [ fftw gtk2 lv2 libsamplerate libsndfile zita-convolver ];

  nativeBuildInputs = [  pkgconfig ];

  postBuild = "make convert4chan";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir "$out/include"
    mkdir -p "$out/share/doc"

    make PREFIX="$out" INSTDIR="$out/lib/lv2" install
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
