{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  pname = "shelfMultiBand";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "shelfMultiBand";
    rev = "V${version}";
    sha256 = "1b1h4z5fs2xm7wvw11p9wnd0bxs3m88124f5phh0gwvpsdrd0im5";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    faust2jaqt -vec -double -time -t 99999 shelfMultiBand.dsp
    faust2jaqt -vec -double -time -t 99999 shelfMultiBandMono.dsp
    faust2lv2 -vec -double -time -gui -t 99999 shelfMultiBandMono.dsp
    faust2lv2 -vec -double -time -gui -t 99999 shelfMultiBand.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp shelfMultiBand $out/bin/
    cp shelfMultiBandMono $out/bin/
    mkdir -p $out/lib/lv2
    cp -r shelfMultiBand.lv2/ $out/lib/lv2
    cp -r shelfMultiBandMono.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "A multiband compressor made from shelving filters.";
    homepage = "https://github.com/magnetophon/shelfMultiBand";
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
