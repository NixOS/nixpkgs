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
  version = "0.11.0";
  vendorHash = "sha256-ZMzlqUyNmp0zR5KC8yB7zuqTAjE6C3kIhdgz9nin5sA=";

  src = fetchFromGitHub {
    owner = "robherley";
    repo = "snips.sh";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bwnn+kl8uv7ln5mjlq5I+QM5wJbLFdZJAyQIvwG6kAI=";
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
