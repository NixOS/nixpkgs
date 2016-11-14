{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  name = "faustCompressors-v${version}";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "faustCompressors";
    rev = "v${version}";
    sha256 = "0mkram2hm7i5za7pfn5crh2arbajk8praksxzgjx90rrxwl1y3d1";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    for f in *.dsp;
    do
      faust2jaqt -time -double -t 99999 $f
    done

    sed -i "s|\[ *scale *: *log *\]||g ; s|\btgroup\b|hgroup|g" "compressors.lib"

    for f in *.dsp;
    do
      faust2lv2  -time -double -gui -t 99999 $f
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mv *.lv2/ $out/lib/lv2
    mkdir -p $out/bin
    for f in $(find . -executable -type f);
    do
      cp $f $out/bin/
    done
  '';

  meta = {
    description = "A collection of bread and butter compressors";
    homepage = https://github.com/magnetophon/faustCompressors;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
