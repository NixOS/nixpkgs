{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "gosmee";
  version = "0.28.2";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gosmee";
    rev = "v${version}";
    hash = "sha256-xkdJCmgBJh5oDELvm7qP/pC0FxqmVsXPGBhN7twp3Ug=";
  };
  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    printf ${version} > gosmee/templates/version
  '';

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd gosmee \
      --bash <($out/bin/gosmee completion bash) \
      --fish <($out/bin/gosmee completion fish) \
      --zsh <($out/bin/gosmee completion zsh)
  '';

  meta = {
    description = "Command line server and client for webhooks deliveries (and https://smee.io)";
    homepage = "https://github.com/chmouel/gosmee";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      vdemeester
      chmouel
    ];
  };
}
