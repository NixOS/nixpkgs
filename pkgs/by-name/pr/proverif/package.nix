{
  lib,
  stdenv,
  fetchurl,
  ocamlPackages,
  makeBinaryWrapper,
  graphviz,
  m4,

  enable_interact ? false,
}:

stdenv.mkDerivation rec {
  pname = "proverif";
  version = "2.05";

  src = fetchurl {
    url = "https://bblanche.gitlabpages.inria.fr/proverif/proverif${version}.tar.gz";
    hash = "sha256-SHH1PDKrSgRmmgYMSIa6XZCASWlj+5gKmmLSxCnOq8Q=";
  };

  strictDeps = true;

  nativeBuildInputs =
    with ocamlPackages;
    [
      ocaml
      findlib
    ]
    ++ lib.optionals enable_interact [ makeBinaryWrapper ];

  buildInputs = lib.optionals enable_interact [
    ocamlPackages.lablgtk
  ];
  nativeCheckInputs = [ m4 ];

  buildPhase = ''
    runHook preBuild
    ${if enable_interact then "./build" else "./build -nointeract"}
    runHook postBuild
  '';

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    ./test
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    install -D -t $out/bin proverif proveriftotex
    install -D -t $out/share/emacs/site-lisp/ emacs/proverif.el

    ${lib.optionalString enable_interact ''
      install -D -t $out/bin proverif_interact
      wrapProgram $out/bin/proverif_interact \
        --prefix PATH : ${lib.makeBinPath [ graphviz ]}
    ''}

    runHook postInstall
  '';

  meta = {
    description = "Cryptographic protocol verifier in the formal model";
    homepage = "https://bblanche.gitlabpages.inria.fr/proverif/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      thoughtpolice
      vbgl
    ];
  };
}
