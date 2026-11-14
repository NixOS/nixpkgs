{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shelfMultiBand";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "shelfMultiBand";
    rev = "V${finalAttrs.version}";
    hash = "sha256-pUbQctN38wcgvMURERCqQ/cFmuXphsA3P7UL7conMKw=";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    faust2jaqt -vec -double -time -t 99999 shelfMultiBand.dsp
    faust2jaqt -vec -double -time -t 99999 shelfMultiBandMono.dsp
    faust2lv2 -vec -double -time -gui -t 99999 shelfMultiBandMono.dsp
    faust2lv2 -vec -double -time -gui -t 99999 shelfMultiBand.dsp
  '';

  installPhase = ''
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
    mkdir -p $out/lib/lv2
    cp -r shelfMultiBand.lv2/ $out/lib/lv2
    cp -r shelfMultiBandMono.lv2/ $out/lib/lv2
  '';

  meta = {
    description = "Multiband compressor made from shelving filters";
    homepage = "https://github.com/magnetophon/shelfMultiBand";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})
