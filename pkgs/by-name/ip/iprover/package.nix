{
  lib,
  stdenv,
  fetchFromGitLab,
  ocamlPackages,
  eprover,
  z3,
  zlib,
}:

stdenv.mkDerivation {
  pname = "iprover";
  version = "3.9.2";

  src = fetchFromGitLab {
    owner = "korovin";
    repo = "iprover";
    rev = "v3.9.2";
    hash = "sha256-CbqPtP2pKLFgo67EF0IhvIdv1dAog2vb3Es0asmmSyY=";
  };

  postPatch = ''
    substituteInPlace configure --replace Linux Debian
  '';

  strictDeps = true;

  nativeBuildInputs = [
    eprover
  ]
  ++ (with ocamlPackages; [
    ocaml
    findlib
  ]);
  buildInputs = [
    zlib
    ocamlPackages.z3
    z3
  ]
  ++ (with ocamlPackages; [
    ocamlgraph
    yojson
    zarith
  ]);

  preConfigure = "patchShebangs .";

  env = {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp iproveropt "$out/bin"

    echo -e "#! ${stdenv.shell}\\n$out/bin/iproveropt --clausifier \"${eprover}/bin/eprover\" --clausifier_options \" --tstp-format --silent --cnf \" \"\$@\"" > "$out"/bin/iprover
    chmod a+x  "$out"/bin/iprover
    runHook postInstall
  '';

  meta = {
    description = "Automated first-order logic theorem prover";
    homepage = "http://www.cs.man.ac.uk/~korovink/iprover/";
    maintainers = with lib.maintainers; [
      raskin
    ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3;
  };
}
