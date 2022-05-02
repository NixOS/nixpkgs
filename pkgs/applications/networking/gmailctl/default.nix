{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "sha256-tj+jKJuKwuqic/qfaUbf+Tao1X2FW0VVoGwqyx3q+go=";
  };

  vendorSha256 = "sha256-aBw9C488a3Wxde3QCCU0eiagiRYOS9mkjcCsB2Mrdr0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd gmailctl \
      --bash <($out/bin/gmailctl completion bash) \
      --fish <($out/bin/gmailctl completion fish) \
      --zsh <($out/bin/gmailctl completion zsh)
  '';

  doCheck = false;

  meta = with lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar SuperSandro2000 ];
  };
}
