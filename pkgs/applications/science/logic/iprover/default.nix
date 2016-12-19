{ stdenv, fetchurl, ocaml, eprover }:

stdenv.mkDerivation rec {
  name = "iprover-${version}";
  version = "0.8.1";

  src = fetchurl {
    url = "http://iprover.googlecode.com/files/iprover_v${version}.tar.gz";
    sha256 = "15qn523w4l296np5rnkwi50a5x2xqz0kaza7bsh9bkazph7jma7w";
  };

  buildInputs = [ ocaml eprover ];

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
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    downloadPage = "http://code.google.com/p/iprover/downloads/list";
  };
}
