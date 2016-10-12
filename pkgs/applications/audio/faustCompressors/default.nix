{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "faustCompressors-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "faustCompressors";
    rev = "${version}";
    sha256 = "114dw3qzfr67fclf8y65i1ic6v9jrkvccymi82cddlz45y5i02ys";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  patchPhase = ''
    # just a demo:
    rm -rf slidingsum.dsp
  '';

  buildPhase = ''
    for f in *.dsp;
    do
      faust2jaqt -double -t 99999 $f
    done
    # workaround for a bug in faust2lv2:
    # https://bitbucket.org/agraef/faust-lv2/issues/7/scale-log-breaks-plugins
    sed -i "s|\[scale:log\]||" "compressors.lib"
    cat compressors.lib
    for f in *.dsp;
    do
      faust2lv2 -double -gui -t 99999 $f
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
