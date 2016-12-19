{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  name = "LazyLimiter-${version}";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "LazyLimiter";
    rev = "V${version}";
    sha256 = "10xdydwmsnkx8hzsm74pa546yahp29wifydbc48yywv3sfj5anm7";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    faust2jaqt -vec -time -t 99999 LazyLimiter.dsp
    sed -i "s|\[ *scale *: *log *\]||g ; s|\btgroup\b|hgroup|g" "GUI.lib"
    faust2lv2 -vec -time -t 99999  -gui LazyLimiter.dsp
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
