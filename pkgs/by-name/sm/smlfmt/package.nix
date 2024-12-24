{
  lib,
  stdenv,
  fetchFromGitHub,
  mlton,
}:

stdenv.mkDerivation rec {
  pname = "smlfmt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "shwestrick";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qwhYOZrck028NliPDnqFZel3IxopQzouhHq6R7DkfPE=";
  };

  nativeBuildInputs = [ mlton ];

  installPhase = ''
    runHook preInstall
    install -Dm755 -t $out/bin smlfmt
    runHook postInstall
  '';

  meta = {
    description = "Custom parser/auto-formatter for Standard ML";
    mainProgram = "smlfmt";
    longDescription = ''
      A custom parser and code formatter for Standard ML, with helpful error messages.

      Supports SML source files (.sml, .sig, .fun, etc.) as well as MLBasis
      compilation files (.mlb) using MLton conventions, including MLBasis path
      maps.
    '';

    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ munksgaard ];
    platforms = mlton.meta.platforms;
    homepage = "https://github.com/shwestrick/smlfmt";
  };
}
