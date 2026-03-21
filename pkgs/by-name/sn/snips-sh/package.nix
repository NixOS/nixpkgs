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
  version = "0.7.0";
  vendorHash = "sha256-smmfGpnHcY570RelGbE3R7cOiYLaJs+LE+H2eq8j81A=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WsfDFgu1a55i3lu5/nlNr7TCYOrpKMX2vsK6SqT3vrw=";
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
