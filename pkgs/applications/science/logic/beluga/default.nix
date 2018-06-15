{ stdenv, fetchFromGitHub, ocamlPackages, omake }:

stdenv.mkDerivation {
  name = "beluga-20180403";

  src = fetchFromGitHub {
    owner  = "Beluga-lang";
    repo   = "Beluga";
    rev    = "046aa59f008be70a7c4700b723bed0214ea8b687";
    sha256 = "0m68y0r0wdw3mg2jks68bihaww7sg305zdfnic1rkndq2cxv0mld";
  };

  nativeBuildInputs = with ocamlPackages; [ findlib ocamlbuild omake ];
  buildInputs = with ocamlPackages; [ ocaml ulex ocaml_extlib ];

  installPhase = ''
    mkdir -p $out
    cp -r bin $out/

    mkdir -p $out/share/beluga
    cp -r tools/ examples/ $out/share/beluga

    mkdir -p $out/share/emacs/site-lisp/beluga/
    cp -r tools/beluga-mode.el $out/share/emacs/site-lisp/beluga
  '';

  meta = {
    description = "A functional language for reasoning about formal systems";
    homepage    = http://complogic.cs.mcgill.ca/beluga/;
    license     = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.bcdarwin ];
    platforms   = stdenv.lib.platforms.unix;
  };
}
