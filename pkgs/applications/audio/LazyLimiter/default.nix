{ stdenv, fetchFromGitHub, faust2jack, faust2lv2 }:
stdenv.mkDerivation rec {
  name = "LazyLimiter-${version}";
  version = "0.3.01";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "LazyLimiter";
    rev = "v${version}";
    sha256 = "1yx9d5cakmqbiwb1j9v2af9h5lqzahl3kaamnyk71cf4i8g7zp3l";
  };

  buildInputs = [ faust2jack faust2lv2 ];

  buildPhase = ''
    faust2jack -t 99999 LazyLimiter.dsp
    faust2lv2 -t 99999 LazyLimiter.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp LazyLimiter $out/bin/
    mkdir -p $out/lib/lv2
    cp -r LazyLimiter.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "A fast yet clean lookahead limiter for jack and lv2";
    homepage = https://magnetophon.github.io/LazyLimiter/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
