{ buildGoModule, fetchFromGitHub, installShellFiles, lib }:

buildGoModule rec {
  pname = "humioctl";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "humio";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-/oMsNAUCM1FdGDfn7pxkfT1hJlJJDbaxEXvGGJy0VgE=";
  };

  vendorHash = "sha256-ABXBzmRBByet6Jb/uvcvpdGHC5MSAKvZUnsyY2d2nGs=";

  ldflags = [ "-s" "-w" "-X main.version=${version}" ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd humioctl \
      --bash <($out/bin/humioctl completion bash) \
      --zsh <($out/bin/humioctl completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/humio/cli";
    description = "A CLI for managing and sending data to Humio";
    license = licenses.asl20;
    maintainers = with maintainers; [ lucperkins ];
    mainProgram = "humioctl";
  };
}
