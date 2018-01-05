{ stdenv, go, removeReferencesTo }:

stdenv.mkDerivation {
  name = "substitute-paths";

  src = ./.;

  nativeBuildInputs = [ go removeReferencesTo ];

  buildPhase = ''
    go build -o $name
    remove-references-to -t ${go} $name
  '';

  checkPhase = ''
    go test
  '';

  installPhase = ''
    install -Dt $out/bin $name
  '';

  doCheck = true;
}
