{ lib, stdenv, fetchgit, fftw, gtk2, lv2, libsamplerate, libsndfile, pkg-config, zita-convolver }:

stdenv.mkDerivation rec {
  pname = "ir.lv2";
  version = "0-unstable-2018-06-21";

  src = fetchgit {
    url = "https://git.hq.sig7.se/ir.lv2.git";
    rev = "38bf3ec7d370d8234dd55be99c14cf9533b43c60";
    sha256 = "sha256-5toZYQX2oIAfQ5XPMMN+HGNE4FOE/t6mciih/OpU1dw=";
  };

  buildInputs = [ fftw gtk2 lv2 libsamplerate libsndfile zita-convolver ];

  nativeBuildInputs = [  pkg-config ];

  env.NIX_CFLAGS_COMPILE = "-fpermissive";

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
    mainProgram = "convert4chan";
  };
}
