{ lib, stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "LazyLimiter";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "LazyLimiter";
    rev = "V${version}";
    sha256 = "10xdydwmsnkx8hzsm74pa546yahp29wifydbc48yywv3sfj5anm7";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -vec -time -t 99999 LazyLimiter.dsp
    faust2lv2 -vec -time -t 99999  -gui LazyLimiter.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r LazyLimiter.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Fast yet clean lookahead limiter for jack and lv2";
    homepage = "https://magnetophon.github.io/LazyLimiter/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
  };
}
