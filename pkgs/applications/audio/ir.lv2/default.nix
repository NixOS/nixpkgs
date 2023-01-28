{ lib, stdenv, fetchFromGitHub, fftw, gtk2, lv2, libsamplerate, libsndfile, pkg-config, zita-convolver }:

stdenv.mkDerivation rec {
  pname = "ir.lv2";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "tomszilagyi";
    repo = "ir.lv2";
    rev = version;
    sha256 = "1p6makmgr898fakdxzl4agh48qqwgv1k1kwm8cgq187n0mhiknp6";
  };

  buildInputs = [ fftw gtk2 lv2 libsamplerate libsndfile zita-convolver ];

  nativeBuildInputs = [  pkg-config ];

  postPatch = ''
     # Fix build with lv2 1.18: https://github.com/tomszilagyi/ir.lv2/pull/20
     find . -type f -exec fgrep -q LV2UI_Descriptor {} \; \
       -exec sed -i {} -e 's/const struct _\?LV2UI_Descriptor/const LV2UI_Descriptor/' \;
   '';


  postBuild = "make convert4chan";

  installPhase = ''
    mkdir -p "$out/bin"
    mkdir "$out/include"
    mkdir -p "$out/share/doc"

    make PREFIX="$out" INSTDIR="$out/lib/lv2" install
    install -Dm755 convert4chan "$out/bin/convert4chan"
  '';

  meta = with lib; {
    homepage = "http://factorial.hu/plugins/lv2/ir";
    description = "Zero-latency, realtime, high performance signal convolver especially for creating reverb effects";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
  };
}
