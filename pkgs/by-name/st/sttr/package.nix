{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "sttr";
  version = "0.2.26";

  src = fetchFromGitHub {
    owner = "abhimanyu003";
    repo = "sttr";
    rev = "v${version}";
    hash = "sha256-VyO4NyiTWWQJjbhKHoIC86B4KdSowlrR6XR3HCKr0U4=";
  };

  vendorHash = "sha256-g35BCThoym9awjMObMUecRkkLsQyEIviYc4rdQsIICY=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
  ];

  postInstall = ''
    installShellCompletion --cmd sttr \
      --bash <($out/bin/sttr completion bash) \
      --fish <($out/bin/sttr completion fish) \
      --zsh <($out/bin/sttr completion zsh)
  '';

  meta = {
    description = "Cross-platform cli tool to perform various operations on string";
    homepage = "https://github.com/abhimanyu003/sttr";
    changelog = "https://github.com/abhimanyu003/sttr/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ligthiago ];
    mainProgram = "sttr";
  };
}
