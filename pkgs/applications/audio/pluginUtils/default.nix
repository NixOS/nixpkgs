{ stdenv, fetchFromGitHub, faust2jaqt, faust2lv2gui }:
stdenv.mkDerivation rec {
  name = "pluginUtils-${version}";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "magnetophon";
    repo = "pluginUtils";
    rev = "V${version}";
    sha256 = "0dv64cy5ip9sw8ppi3xff1y1vzxn212w1ryy5ipb5dq8rzk47djh";
  };

  buildInputs = [ faust2jaqt faust2lv2gui ];

  buildPhase = ''
    for f in *.dsp
      do
        echo "Building lv2 for $f"
        faust2lv2 -vec -time -gui -t 99999 "$f"
        echo "Building jack standalone for $f"
        faust2jaqt -vec -time -t 99999 "$f"
      done
  '';

  installPhase = ''
    rm -f *.dsp
    rm -f *.lib
    mkdir -p $out/lib/lv2
    mv *.lv2/ $out/lib/lv2
    mkdir -p $out/bin
    cp * $out/bin/
  '';

  meta = {
    description = "Some simple utility lv2 plugins";
    homepage = https://github.com/magnetophon/pluginUtils;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
  };
}
