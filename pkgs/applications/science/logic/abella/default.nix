{ stdenv, fetchurl, rsync, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "abella-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "http://abella-prover.org/distributions/${name}.tar.gz";
    sha256 = "1hnccjlyzwgz7kqsr4xmx9y4wmalbxsj0g6fxdk6xrgpc84ihw2c";
  };

  buildInputs = [ rsync ] ++ (with ocamlPackages; [ ocaml ocamlbuild findlib ]);

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
    homepage = http://abella-prover.org/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ bcdarwin ciil ];
    platforms = stdenv.lib.platforms.unix;
  };
}
