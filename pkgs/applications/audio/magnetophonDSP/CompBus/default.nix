{
  lib,
  stdenv,
  fetchFromGitHub,
  faust2jaqt,
  faust2lv2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "CompBus";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "CompBus";
    rev = "V${finalAttrs.version}";
    hash = "sha256-XygCfUyWU3CPEq4qEaas4g8nTr1qSBQdsY3M9wEyEno=";
  };

  buildInputs = [
    faust2jaqt
    faust2lv2
  ];

  dontWrapQtApps = true;

  buildPhase = ''
    for f in *.dsp;
    do
      faust2jaqt -time -vec -double -t 99999 $f
    done

    for f in *.dsp;
    do
      faust2lv2  -time -vec -double -gui -t 99999 $f
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mv *.lv2/ $out/lib/lv2
    mkdir -p $out/bin
    for f in $(find . -executable -type f); do
      cp $f $out/bin/
    done
  '';

  meta = {
    description = "Group of compressors mixed into a bus, sidechained from that mix bus. For jack and lv2";
    homepage = "https://github.com/magnetophon/CompBus";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.magnetophon ];
  };
})
