{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
  libtensorflow,
  withTensorflow ? false,
  nixosTests,
}:
buildGoModule rec {
  pname = "snips-sh";
  version = "0.6.0";
  vendorHash = "sha256-HIGPCLUZTrfJqFsf3k6lbvI05jhS6aXHvYKCGs74JT4=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${version}";
    hash = "sha256-z92DIm0OPUXKVXPjQRpAb+YOdegI9bjb/tYnLEvb0rU=";
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
}
