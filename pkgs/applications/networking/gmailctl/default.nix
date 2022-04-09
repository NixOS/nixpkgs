{ lib
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "gmailctl";
  # on an unstable version because of https://github.com/mbrt/gmailctl/issues/232
  # and https://github.com/mbrt/gmailctl/commit/484bb689866987580e0576165180ef06375a543f
  version = "unstable-2022-03-24";

  src = fetchFromGitHub {
    owner = "mbrt";
    repo = "gmailctl";
    rev = "484bb689866987580e0576165180ef06375a543f";
    sha256 = "sha256-hIoS64QEDJ1qq3KJ2H8HjgQl8SxuIo+xz7Ot8CdjjQA=";
  };

  vendorSha256 = "sha256-KWM20a38jZ3/a45313kxY2LaCQyiNMEdfdIV78phrBo=";

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
