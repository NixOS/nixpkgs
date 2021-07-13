{ lib, stdenv, fetchFromGitHub, ocaml }:

stdenv.mkDerivation  rec {
  pname = "coq2html";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "xavierleroy";
    repo = "coq2html";
    rev = "v${version}";
    sha256 = "sha256-ty/6A3wivjDCrmlZAcZyaIwQQ+vPBJm9MhtW6nZcV3s=";
  };

  nativeBuildInputs = [ ocaml ];

  installPhase = ''
    mkdir -p $out/bin
    cp coq2html $out/bin
  '';

  meta = with lib; {
    description = "HTML documentation generator for Coq source files";
    longDescription = ''
      coq2html is an HTML documentation generator for Coq source files. It is
      an alternative to the standard coqdoc documentation generator
      distributed along with Coq. The major feature of coq2html is its ability
      to fold proof scripts: in the generated HTML, proof scripts are
      initially hidden, but can be revealed one by one by clicking on the
      "Proof" keyword.
    '';
    homepage = "https://github.com/xavierleroy/coq2html";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ jwiegley siraben ];
    platforms = platforms.unix;
  };
}
