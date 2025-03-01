{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "cliam";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "securisec";
    repo = pname;
    rev = version;
    hash = "sha256-59nPoH0+k1umMwFg95hQHOr/SRGKqr1URFG7xtVRiTs=";
  };

  vendorHash = "sha256-Tcz8W/PX+9WE+0iFVhqHuElJI7qWD+AdwOKdTc7FQTE=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/securisec/cliam/cli/version.Version=${version}"
  ];

  postBuild = ''
    # should be called cliam
    mv $GOPATH/bin/{cli,cliam}
  '';

  postInstall = ''
    installShellCompletion --cmd cliam \
      --bash <($out/bin/cliam completion bash) \
      --fish <($out/bin/cliam completion fish) \
      --zsh <($out/bin/cliam completion zsh)
  '';

  meta = with lib; {
    description = "Cloud agnostic IAM permissions enumerator";
    mainProgram = "cliam";
    homepage = "https://github.com/securisec/cliam";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
