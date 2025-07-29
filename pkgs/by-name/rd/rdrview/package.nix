{
  lib,
  stdenv,
  fetchFromGitHub,
  libxml2,
  curl,
  libseccomp,
  installShellFiles,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rdrview";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "eafer";
    repo = "rdrview";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wYeDtgfq6/W92WguPh9wiFaxR7CWSfLnfqTX1N7eT10=";
  };

  buildInputs = [
    libxml2
    curl
    libseccomp
  ];
  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall
    install -Dm755 rdrview -t $out/bin
    installManPage rdrview.1
    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Command line tool to extract main content from a webpage";
    homepage = "https://github.com/eafer/rdrview";
    license = licenses.asl20;
    maintainers = with maintainers; [ djanatyn ];
    mainProgram = "rdrview";
  };

  passthru.updateScript = nix-update-script { };
})
