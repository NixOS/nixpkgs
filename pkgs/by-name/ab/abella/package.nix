{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  rsync,
  ocamlPackages,
  dune,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abella";
  version = "2.0.8";

  src = fetchurl {
    url = "http://abella-prover.org/distributions/abella-${finalAttrs.version}.tar.gz";
    hash = "sha256-80b/RUpE3KRY0Qu8eeTxAbk6mwGG6jVTPOP0qFjyj2M=";
  };

  patches = [
    # Compatibility with OCaml 5.5
    (fetchpatch {
      url = "https://github.com/abella-prover/abella/commit/85dd329c03bf8866975ca0ea7278553d64f8d17f.patch";
      includes = [ "src/*.ml" ];
      hash = "sha256-adS2QGwqhLjiZo/Q4KUbpJVp8D/eNy/Ux17/nY3XMh4=";
    })
  ];

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    rsync
    dune
  ]
  ++ (with ocamlPackages; [
    ocaml
    menhir
    findlib
  ]);
  buildInputs = with ocamlPackages; [
    cmdliner
    yojson
  ];

  installPhase = ''
    mkdir -p $out/bin
    rsync -av _build/default/src/abella.exe    $out/bin/abella

    mkdir -p $out/share/emacs/site-lisp/abella/
    rsync -av emacs/    $out/share/emacs/site-lisp/abella/

    mkdir -p $out/share/abella/examples
    rsync -av examples/ $out/share/abella/examples/
  '';

  meta = {
    description = "Interactive theorem prover";
    mainProgram = "abella";
    longDescription = ''
      Abella is an interactive theorem prover based on lambda-tree syntax.
      This means that Abella is well-suited for reasoning about the meta-theory
      of programming languages and other logical systems which manipulate
      objects with binding.
    '';
    homepage = "https://abella-prover.org";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.bcdarwin ];
    platforms = lib.platforms.unix;
  };
})
