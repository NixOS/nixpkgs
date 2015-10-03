{ stdenv, fetchurl, fftw, gtk, lv2, libsamplerate, libsndfile, pkgconfig, zita-convolver }:

stdenv.mkDerivation rec {
  name = "ir.lv2-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "http://factorial.hu/system/files/${name}.tar.gz";
    sha256 = "17a6h2mv9xv41jpbx6bdakkngin4kqzh2v67l4076ddq609k5a7v";
  };

  buildInputs = [ fftw gtk lv2 libsamplerate libsndfile pkgconfig zita-convolver ];

  buildPhase = ''
    make
    make convert4chan
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir "$out/include"
    mkdir -p "$out/share/doc"

    make PREFIX="$out" install
    install -Dm755 convert4chan "$out/bin/convert4chan"
    # fixed location
    sed -i 's/, but seem like its gone://' README
    sed -i  's@rhythminmind.net/1313@rhythminmind.net/STN@' README
    install -Dm644 README "$out/share/doc/README"
  '';

  meta = with stdenv.lib; {
    homepage = http://factorial.hu/plugins/lv2/ir;
    description = "Zero-latency, realtime, high performance signal convolver especially for creating reverb effects";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
