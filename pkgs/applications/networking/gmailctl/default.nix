{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gmailctl";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "v${version}";
    sha256 = "sha256-1gOixuOvPHEjnnDNNda9sktnhffovOfeG4XDrLRRMlE=";
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

  vendorSha256 = "sha256-Yv3OGHFOmenst/ujUgvCaSEjwwBf3W9n+55ztVhuWjo=";

  doCheck = false;

  meta = with lib; {
    description = "Declarative configuration for Gmail filters";
    homepage = "https://github.com/mbrt/gmailctl";
    license = licenses.mit;
    maintainers = [ maintainers.doronbehar ];
    platforms = platforms.unix;
  };
}
