{ stdenv, fetchurl, ocaml, eprover, zlib }:

stdenv.mkDerivation rec {
  name = "iprover-${version}";
  version = "2018_Jul_24_11h";

  src = fetchurl {
    url = "http://www.cs.man.ac.uk/~korovink/iprover/iprover_${version}.tar.gz";
    sha256 = "1iqim11flzm56aaysasl5whajcv1gq31hkidaqfr8ww7kwl1h06p";
  };

  buildInputs = [ ocaml eprover zlib ];

  preConfigure = ''patchShebangs .'';

  installPhase = ''
    mkdir -p "$out/bin"
    cp iproveropt "$out/bin"

    mkdir -p "$out/share/${name}"
    cp *.p "$out/share/${name}"
    echo -e "#! /bin/sh\\n$out/bin/iproveropt --clausifier \"${eprover}/bin/eprover\" --clausifier_options \" --tstp-format --silent --cnf \" \"\$@\"" > "$out"/bin/iprover
    chmod a+x  "$out"/bin/iprover
  '';

  meta = with stdenv.lib; {
    description = "An automated first-order logic theorem prover";
    homepage = http://www.cs.man.ac.uk/~korovink/iprover/;
    maintainers = with maintainers; [ raskin gebner ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
