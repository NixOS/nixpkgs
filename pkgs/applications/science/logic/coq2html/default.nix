{ stdenv, lib, make, fetchgit, ocaml }:

let 
  version = "20170720";
in

stdenv.mkDerivation {
  name = "coq2html-${version}";

  src = fetchgit {
    url = "https://github.com/xavierleroy/coq2html";
    rev = "e2b94093c6b9a877717f181765e30577de22439e";
    sha256 = "1x466j0pyjggyz0870pdllv9f5vpnfrgkd0w7ajvm9rkwyp3f610";
  };

  buildInputs = [ make ocaml ];

  installPhase = ''
    mkdir -p $out/bin
    cp coq2html $out/bin
  '';

  meta = with stdenv.lib; {
    description = "coq2html is an HTML documentation generator for Coq source files";
    longDescription = ''
      coq2html is an HTML documentation generator for Coq source files. It is
      an alternative to the standard coqdoc documentation generator
      distributed along with Coq. The major feature of coq2html is its ability
      to fold proof scripts: in the generated HTML, proof scripts are
      initially hidden, but can be revealed one by one by clicking on the
      "Proof" keyword.
    '';
    homepage = https://github.com/xavierleroy/coq2html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.unix;
  };
}
