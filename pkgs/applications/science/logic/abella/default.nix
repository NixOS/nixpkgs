{ lib, stdenv, fetchurl, rsync, ocamlPackages }:

stdenv.mkDerivation rec {
  pname = "abella";
  version = "2.0.7";

  src = fetchurl {
    url = "http://abella-prover.org/distributions/${pname}-${version}.tar.gz";
    sha256 = "sha256-/eOiebMFHgrurtrSHPlgZO3xmmxBOUmyAzswXZLd3Yc=";
  };

  strictDeps = true;

  nativeBuildInputs = [ rsync ] ++ (with ocamlPackages; [ ocaml ocamlbuild findlib ]);

  installPhase = ''
    mkdir -p $out/bin
    rsync -av abella    $out/bin/

    mkdir -p $out/share/emacs/site-lisp/abella/
    rsync -av emacs/    $out/share/emacs/site-lisp/abella/

    mkdir -p $out/share/abella/examples
    rsync -av examples/ $out/share/abella/examples/
  '';

  meta = {
    description = "Interactive theorem prover";
    longDescription = ''
      Abella is an interactive theorem prover based on lambda-tree syntax.
      This means that Abella is well-suited for reasoning about the meta-theory
      of programming languages and other logical systems which manipulate
      objects with binding.
    '';
    homepage = "http://abella-prover.org/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ bcdarwin ciil ];
    platforms = lib.platforms.unix;
  };
}
