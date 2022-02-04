{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "sha256-JuE8+OW+qM6tir4A25tN2GTXQIkcKVE4uKbZNSTcNlA=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    installShellCompletion --cmd gmailctl \
      --bash <($out/bin/gmailctl completion bash) \
      --fish <($out/bin/gmailctl completion fish) \
      --zsh <($out/bin/gmailctl completion zsh)
  '';

  vendorSha256 = "sha256-nAczO439tRiQU9f9LbJVENJiURVRnBAInwUp699RxOY=";

  doCheck = false;

  meta = with lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = with maintainers; [ doronbehar SuperSandro2000 ];
  };
}
