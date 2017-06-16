{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2 }:
stdenv.mkDerivation rec {
  name = "faustCompressors-v${version}";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "faustCompressors";
    rev = "v${version}";
    sha256 = "144f6g17q4m50kxzdncsfzdyycdfprnpwdaxcwgxj4jky1xsha1d";
  };

  buildInputs = [ faust2jaqt faust2lv2 ];

  buildPhase = ''
    for f in *.dsp;
    do
      echo "compiling standalone from" $f
      faust2jaqt -time -double -t 99999 $f
    done

    sed -i "s|\[ *scale *: *log *\]||g ; s|\btgroup\b|hgroup|g" "compressors.lib"

    for f in *.dsp;
    do
      echo "compiling plugin from" $f
      faust2lv2  -time -double -gui -t 99999 $f
    done
  '';

  installPhase = ''
    mkdir -p $out/lib/lv2
    mv *.lv2/ $out/lib/lv2
    mkdir -p $out/bin
    rm newlib.sh
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
