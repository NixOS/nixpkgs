{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "gosmee";
  version = "0.21.0";

  src = fetchFromGitHub {
    owner = "chmouel";
    repo = "gosmee";
    rev = "v${version}";
    sha256 = "sha256-VNBz6roula/YlsYMM1kjQT3TLuQ86/MESzNNkEf/92M=";
  };
  vendorHash = null;

  nativeBuildInputs = [ installShellFiles ];

  postPatch = ''
    printf ${version} > gosmee/templates/version
  '';

  postInstall = ''
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
