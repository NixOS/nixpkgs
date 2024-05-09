{ lib, stdenv, fetchFromGitLab, ocamlPackages, eprover, z3, zlib }:

stdenv.mkDerivation rec {
  pname = "iprover";
  version = "3.8.1";

  src = fetchFromGitLab {
    owner = "korovin";
    repo = pname;
    rev = "f61edb113b705606c7314dc4dce0687832c3169f";
    hash = "sha256-XXqbEoYKjoktE3ZBEIEFjLhA1B75zhnfPszhe8SvbI8=";
  };

  postPatch = ''
    substituteInPlace configure --replace Linux Debian
  '';

  strictDeps = true;

  nativeBuildInputs = [ eprover ] ++ (with ocamlPackages; [
    ocaml findlib
  ]);
  buildInputs = [ zlib ocamlPackages.z3 z3 ] ++ (with ocamlPackages; [
    ocamlgraph yojson zarith
  ]);

  preConfigure = "patchShebangs .";

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/bin"
    cp iproveropt "$out/bin"

    echo -e "#! ${stdenv.shell}\\n$out/bin/iproveropt --clausifier \"${eprover}/bin/eprover\" --clausifier_options \" --tstp-format --silent --cnf \" \"\$@\"" > "$out"/bin/iprover
    chmod a+x  "$out"/bin/iprover
    runHook postInstall
  '';

  meta = with lib; {
    description = "An automated first-order logic theorem prover";
    homepage = "http://www.cs.man.ac.uk/~korovink/iprover/";
    maintainers = with maintainers; [ raskin gebner ];
    platforms = platforms.linux;
    license = licenses.gpl3;
  };
}
