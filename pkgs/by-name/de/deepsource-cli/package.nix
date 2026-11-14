{ lib
, buildGoModule
, fetchFromGitHub

, installShellFiles

}:
buildGoModule rec {
  pname = "deepsource-cli";
  version = "0.8.6";

  src = fetchFromGitHub {
    repo = "cli";
    owner = "DeepSourceCorp";
    rev = "v${version}";
    hash = "sha256-6uNb4cQVerrlW/eUkjmlO1i1YKYX3qaVdo0i5cczt+I=";
  };

  vendorHash = "sha256-SsMq4ngq3sSOL28ysHTxTF4CT9sIcCIW7yIhBxIPrNs=";

  nativeBuildInputs = [
    installShellFiles
  ];

  excludedPackages = [
    # This test expects some content to be copied and written to and from /tmp directory
    "command/report/tests"
  ];

  postInstall = ''
    installShellCompletion --cmd deepsource \
    --bash <($out/bin/deepsource completion bash) \
    --fish <($out/bin/deepsource completion fish) \
    --zsh <($out/bin/deepsource completion zsh)
  '';


  meta = with lib; {
    homepage = "https://github.com/DeepSourceCorp/cli";
    description = "Command line interface to DeepSource ";
    license = licenses.bsd2;
    maintainers = with maintainers; [ ByteSudoer ];
    mainProgram = "deepsource";
  };
}
