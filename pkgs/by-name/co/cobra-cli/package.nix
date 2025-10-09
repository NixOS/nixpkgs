{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  makeWrapper,
  installShellFiles,
  go,
}:

buildGoModule rec {
  pname = "cobra-cli";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = "cobra-cli";
    rev = "v${version}";
    sha256 = "sha256-E0I/Pxw4biOv7aGVzGlQOFXnxkc+zZaEoX1JmyMh6UE=";
  };

  vendorHash = "sha256-vrtGPQzY+NImOGaSxV+Dvch+GNPfL9XfY4lfCHTGXwY=";

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  allowGoReference = true;

  postPatch = ''
    substituteInPlace "cmd/add_test.go" \
      --replace "TestGoldenAddCmd" "SkipGoldenAddCmd"
    substituteInPlace "cmd/init_test.go" \
      --replace "TestGoldenInitCmd" "SkipGoldenInitCmd"
  '';

  postFixup = ''
    wrapProgram "$out/bin/cobra-cli" \
      --prefix PATH : ${go}/bin
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd cobra-cli \
      --bash <($out/bin/cobra-cli completion bash) \
      --fish <($out/bin/cobra-cli completion fish) \
      --zsh <($out/bin/cobra-cli completion zsh) \

    # Ironically, cobra-cli still uses old, slightly buggy completion code
    # This will correct the #compdef tag and add separate compdef line
    # allowing direct sourcing to also activate the completion
    substituteInPlace "$out/share/zsh/site-functions/_cobra-cli" \
      --replace-fail '#compdef _cobra-cli cobra-cli' "#compdef cobra-cli''\ncompdef _cobra-cli cobra-cli"
  '';

  meta = {
    description = "Cobra CLI tool to generate applications and commands";
    mainProgram = "cobra-cli";
    homepage = "https://github.com/spf13/cobra-cli/";
    changelog = "https://github.com/spf13/cobra-cli/releases/tag/${version}";
    license = lib.licenses.afl20;
    maintainers = [ lib.maintainers.ivankovnatsky ];
  };
}
