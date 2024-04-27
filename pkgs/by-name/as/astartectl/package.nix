{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:
buildGoModule rec {
  pname = "astartectl";
  version = "23.5.0";

  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = "astartectl";
    rev = "v${version}";
    hash = "sha256-4NgDVuYEeJI5Arq+/+xdyUOBWdCLALM3EKVLSFimJlI=";
  };

  vendorHash = "sha256-Syod7SUsjiM3cdHPZgjH/3qdsiowa0enyV9DN8k13Ws=";

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
