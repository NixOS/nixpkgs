{
  lib,
  stdenv,
  fetchurl,
  rsync,
  ocamlPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abella";
  version = "2.0.8";

  src = fetchurl {
    url = "http://abella-prover.org/distributions/abella-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-80b/RUpE3KRY0Qu8eeTxAbk6mwGG6jVTPOP0qFjyj2M=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    rsync
  ]
  ++ (with ocamlPackages; [
    ocaml
    dune_3
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
    maintainers = with lib.maintainers; [
      bcdarwin
      ciil
    ];
    platforms = lib.platforms.unix;
  };
})
