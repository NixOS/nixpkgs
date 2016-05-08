{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "faustCompressors-${version}";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "faustCompressors";
    rev = "v${version}";
    sha256 = "0x5nd2cjhknb4aclhkkjaywx75bi2wj22prgv8n47czi09jcj0jb";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    for f in *.dsp;
    do
      faust2jaqt -double -t 99999 $f
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
