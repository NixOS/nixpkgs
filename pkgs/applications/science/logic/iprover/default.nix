{ stdenv, fetchurl, ocaml, eprover, zlib }:

stdenv.mkDerivation rec {
  pname = "iprover";
  version = "3.1";

  src = fetchurl {
    url = "http://www.cs.man.ac.uk/~korovink/iprover/iprover-v${version}.tar.gz";
    sha256 = "0lik8p7ayhjwpkln1iwf0ri84ramhch74j5nj6z7ph6wfi92pgg8";
  };

  buildInputs = [ ocaml eprover zlib ];

  preConfigure = ''patchShebangs .'';

  installPhase = ''
    mkdir -p "$out/bin"
    cp iproveropt "$out/bin"

    mkdir -p "$out/share/${pname}-${version}"
    cp *.p "$out/share/${pname}-${version}"
    echo -e "#! ${stdenv.shell}\\n$out/bin/iproveropt --clausifier \"${eprover}/bin/eprover\" --clausifier_options \" --tstp-format --silent --cnf \" \"\$@\"" > "$out"/bin/iprover
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
