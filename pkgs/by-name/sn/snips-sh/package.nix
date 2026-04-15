{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
  libtensorflow,
  withTensorflow ? false,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "snips-sh";
  version = "0.9.1";
  vendorHash = "sha256-41REdYiHEZOEsV8qslQoRBbP9H+sdVSZ+KBkZWkZtHM=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-U3ORTWPLJL+vNQ7nYQa2MgW2uQJzV5oIH/062b1dwqc=";
  };

  tags = (lib.optional (!withTensorflow) "noguesser");

  buildInputs = [ sqlite ] ++ (lib.optional withTensorflow libtensorflow);

  passthru.tests = nixosTests.snips-sh;

  meta = {
    description = "Passwordless, anonymous SSH-powered pastebin with a human-friendly TUI and web UI";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    homepage = "https://snips.sh";
    maintainers = with lib.maintainers; [
      jeremiahs
      matthiasbeyer
    ];
    mainProgram = "snips.sh";
  };
})
