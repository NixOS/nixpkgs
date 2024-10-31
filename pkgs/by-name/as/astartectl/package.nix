{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "astartectl";
  version = "24.5.2";

  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = "astartectl";
    rev = "v${version}";
    hash = "sha256-T4/lkeipE7GWq1zTxkoV3MfADlduFKtGuB/dsI4YZZw=";
  };

  vendorHash = "sha256-kVI1DigDlTvrYLVRUYoW+AAkd31d9EehjRJxrqo8OB4=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd astartectl \
      --bash <($out/bin/astartectl completion bash) \
      --fish <($out/bin/astartectl completion fish) \
      --zsh <($out/bin/astartectl completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/astarte-platform/astartectl";
    description = "Astarte command line client utility";
    license = licenses.asl20;
    mainProgram = "astartectl";
    maintainers = with maintainers; [ noaccos ];
  };
}
