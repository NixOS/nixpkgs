{
  lib,
  stdenv,
  fetchFromGitHub,
  mlton,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "smlfmt";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "shwestrick";
    repo = "smlfmt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-k3sAz1auKJpta1RdLX3ugSrc9ibVQJOCOPVmTYS/AZY=";
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
})
