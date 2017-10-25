{ stdenv, fetchurl, rsync, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "abella-${version}";
  version = "2.0.2";

  src = fetchurl {
    url = "http://abella-prover.org/distributions/${name}.tar.gz";
    sha256 = "b56d865ebdb198111f1dcd5b6fbcc0d7fc6dd1294f7601903ba4e3c3322c099c";
  };

  buildInputs = [ rsync ] ++ (with ocamlPackages; [ ocaml ocamlbuild ]);

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
    maintainers = with stdenv.lib.maintainers; [ bcdarwin ];
    platforms = stdenv.lib.platforms.unix;
  };
}
