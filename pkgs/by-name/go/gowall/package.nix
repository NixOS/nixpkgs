{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "gowall";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "Achno";
    repo = "gowall";
    rev = "v${version}";
    hash = "sha256-R7dOONfyzj6V3101Rp/WhUcFpqrSKWEkVm4a2riXZAI=";
  };

  vendorHash = "sha256-H2Io1K2LEFmEPJYVcEaVAK2ieBrkV6u+uX82XOvNXj4=";

  nativeBuildInputs = [ installShellFiles ];
  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gowall \
      --bash <($out/bin/gowall completion bash) \
      --fish <($out/bin/gowall completion fish) \
      --zsh <($out/bin/gowall completion zsh)
  '';

  meta = {
    changelog = "https://github.com/Achno/gowall/releases/tag/v${version}";
    description = "Tool to convert a Wallpaper's color scheme / palette";
    homepage = "https://github.com/Achno/gowall";
    license = lib.licenses.mit;
    mainProgram = "gowall";
    maintainers = with lib.maintainers; [
      crem
      emilytrau
    ];
  };
}
