{
  lib,
  buildGoModule,
  fetchFromGitHub,
  sqlite,
  libtensorflow,
  withTensorflow ? false,
}:
buildGoModule rec {
  pname = "snips-sh";
  version = "0.4.2";
  vendorHash = "sha256-Lp3yousaDkTCruOP0ytfY84vPmfLMgBoTwf+7Q7Q0Lc=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${version}";
    hash = "sha256-IjGXGY75k9VeeHek0V8SrIElmiQ+Q2P5gEDIp7pmQd8=";
  };

  tags = (lib.optional (!withTensorflow) "noguesser");

  buildInputs = [ sqlite ] ++ (lib.optional withTensorflow libtensorflow);

  meta = {
    description = "passwordless, anonymous SSH-powered pastebin with a human-friendly TUI and web UI";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    homepage = "https://snips.sh";
    maintainers = with lib.maintainers; [ jeremiahs ];
    mainProgram = "snips.sh";
  };
}
